class Recruiter < ActiveRecord::Base

  has_many :pings

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
end
