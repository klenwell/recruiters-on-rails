class Recruiter < ActiveRecord::Base

  has_many :pings, dependent: :destroy
  has_many :interviews, dependent: :destroy

  validates :first_name, :email, presence: true
  validates :email, uniqueness: true

  scope :recently_pinged, ->{ joins('LEFT JOIN pings ON pings.recruiter_id = recruiters.id')
    .select('recruiters.*, MIN(pings.date) as first_contact, MAX(pings.date) as last_contact')
    .group('recruiters.id')
    .order('last_contact DESC') }

  def phone=(value)
    self[:phone] = value.gsub(/[^\d+x]/, "")
  end

  def email=(value)
    self[:email] = value.downcase
  end

  def name
    format('%s %s', self.first_name, self.last_name)
  end

  def score
    (pings.any? ? (pings.collect{|ping| ping.value}).sum : 0) +
    (interviews.any? ? (interviews.collect{|interview| interview.total}).sum : 0)
  end

  def self.companies
    # TODO: cache records?
    companies = Recruiter.all.collect do |recruiter|
      recruiter.company
    end
    companies.uniq
  end

  def self.email_company_map
    # TODO: cache records?
    email_company_map = {}
    Recruiter.all.each do |recruiter|
      _, _, address = recruiter.email.rpartition('@')
      email_company_map[address] = recruiter.company
    end
    email_company_map
  end

  def self.find_existing_company_by_email(email)
    _, _, address = email.rpartition('@')
    self.email_company_map[address]
  end

  def self.create_from_import(row)
    key_map = {
      :first_name => [:first_name],
      :last_name => [:last_name],
      :email => [:email_address],
      #:created_on => [:confirm_time]
    }

    # Invert and flatten key map
    flat_key_tuples = []
    key_map.each do |field, row_keys|
      row_keys.each do |row_key|
        flat_key_tuples << [row_key, field]
      end
    end
    flat_key_map = Hash[flat_key_tuples]

    # Map keys
    params = {}
    flat_key_map.each do |row_key, field|
      params[field] = row[row_key]
    end

    # Infer company from email if not set
    if params[:company].nil? && params[:email]
      params[:company] = self.find_existing_company_by_email(params[:email])

      if params[:company].nil?
        _, address = params[:email].split('@')
        address_parts = address.split('.')
        params[:company] = address_parts[-2].titleize
      end
    end

    recruiter = Recruiter.create(params)

    # Add first ping
    if recruiter.persisted?
      recruiter.pings << Ping.create(
        recruiter_id: recruiter.id,
        kind: 'mailchimp import',
        note: 'Imported from CSV file.'
      )
    end

    recruiter
  end
end
