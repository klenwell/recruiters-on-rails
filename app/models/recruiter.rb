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
    write_attribute(:phone, value.gsub(/[^\d+x]/, ""))
  end

  def name
    format('%s %s', self.first_name, self.last_name)
  end

  def score
    (pings.collect{|ping| ping.value}).sum
  end
end
