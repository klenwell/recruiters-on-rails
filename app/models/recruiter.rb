class Recruiter < ActiveRecord::Base
  include Sortable

  has_many :pings, dependent: :destroy
  has_many :merits, dependent: :destroy
  has_many :interviews, dependent: :destroy
  belongs_to :recruiter_list

  validates :first_name, :email, presence: true
  validates :email, uniqueness: true

  scope :recently_pinged, ->{ joins('LEFT JOIN pings ON pings.recruiter_id = recruiters.id')
    .select('recruiters.*, MIN(pings.date) as first_contact, MAX(pings.date) as last_contact')
    .group('recruiters.id')
    .order('last_contact DESC') }

  scope :sorted_by_email, ->{ order('email ASC') }

  #
  # Constants
  #
  CSV_PING_MARKER = '----> [PING]'
  CSV_MERIT_MARKER = '----> [MERIT]'

  #
  # Class Methods
  #
  def self.companies
    companies = Recruiter.all.collect do |recruiter|
      recruiter.company
    end
    companies.uniq
  end

  def self.email_company_map
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
    # Map fields to different CSV columns (will vary by source)
    key_map = {
      :first_name => [:first_name],
      :last_name => [:last_name],
      :email => [:email_address, :email],
      #:created_on => [:confirm_time]
    }

    # Invert and flatten key map
    flat_key_tuples = []
    key_map.each do |field, row_keys|
      flat_key_tuples << [field, field]
      row_keys.each do |row_key|
        flat_key_tuples << [row_key, field]
      end
    end
    flat_key_map = Hash[flat_key_tuples]

    # Map keys
    params = {}
    flat_key_map.each do |row_key, field|
      params[field] = row[row_key] if row[row_key]
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

    # Look for recruiter
    recruiter = where(email: params[:email]).first

    # If recruiter exists, look for associated record
    if recruiter

      # Ping row
      if row[:first_name] == CSV_PING_MARKER
        Ping.create(
          recruiter_id: recruiter.id,
          date: row[:'ping.date'],
          kind: row[:'ping.kind'],
          note: row[:'ping.note']
        )
      end

      # Merit row
      if row[:first_name] == CSV_MERIT_MARKER
        Merit.create(
          recruiter_id: recruiter.id,
          date: row[:'merit.date'],
          reason: row[:'merit.reason'],
          value: row[:'merit.value']
        )
      end

    # Create new recruiter
    else
      recruiter = Recruiter.create(params)

      # Add first ping
      if recruiter.persisted?
        recruiter.pings << Ping.create(
          recruiter_id: recruiter.id,
          date: Date.today,
          kind: 'mailchimp import',
          note: 'Imported from CSV file.'
        )
      end
    end

    recruiter
  end

  def self.export_to_csv(options = {})
    direct_export_fields = ['first_name', 'last_name', 'email', 'company', 'phone']
    ping_export_fields = ['ping.kind', 'ping.note', 'ping.date']
    merit_export_fields = ['merit.reason', 'merit.value', 'merit.date']
    other_export_fields = ['list']

    CSV.generate(options) do |csv|
      csv << direct_export_fields + ping_export_fields + merit_export_fields + other_export_fields
      all.each do |recruiter|
        # Add recruiter line
        list = recruiter.recruiter_list.present? ? recruiter.recruiter_list.name : nil
        recruiter_line = recruiter.attributes.values_at(*direct_export_fields)
        recruiter_line += [nil] * ping_export_fields.length
        recruiter_line += [nil] * merit_export_fields.length
        recruiter_line += [list]
        csv << recruiter_line

        # Add ping lines
        if recruiter.pings
          recruiter.pings.each do |ping|
            ping_attributes = ping_export_fields.collect{|f| f.split('.').last}
            ping_line = [CSV_PING_MARKER, nil, recruiter.email, nil, nil]
            ping_line += ping.attributes.values_at(*ping_attributes)
            ping_line += [nil] * merit_export_fields.length
            ping_line += [nil] * other_export_fields.length
            csv << ping_line
          end
        end

        # Add merit lines
        if recruiter.merits
          recruiter.merits.each do |merit|
            merit_attributes = merit_export_fields.collect{|f| f.split('.').last}
            merit_line = [CSV_MERIT_MARKER, nil, recruiter.email, nil, nil]
            merit_line += [nil] * ping_export_fields.length
            merit_line += merit.attributes.values_at(*merit_attributes)
            merit_line += [nil]
            csv << merit_line
          end
        end
      end
    end
  end

  #
  # Fields / Virtual Fields
  #
  def phone=(value)
    self[:phone] = value.gsub(/[^\d+x]/, "") if value
  end

  def phone
    return nil if self[:phone].nil?
    self[:phone].split('x').first
  end

  def phone_extension
    return nil if self[:phone].nil?
    if self[:phone].split('x').length > 0
      self[:phone].split('x')[1]
    end
  end

  def email=(value)
    self[:email] = value.downcase if value
  end

  def name
    format('%s %s', self.first_name, self.last_name)
  end

  def score
    (pings.any? ? (pings.collect{|ping| ping.value}).sum : 0) +
    (merits.any? ? (merits.collect{|merit| merit.value}).sum : 0) +
    (interviews.any? ? (interviews.collect{|interview| interview.total}).sum : 0)
  end

  def last_contact
    pings.any? ? pings.last.date : nil
  end

  def timeline
    events = pings + merits + interviews
    events.sort_by{|event| event.date}
  end
end
