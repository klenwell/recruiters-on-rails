class Recruiter < ActiveRecord::Base

  validates :first_name, :email, presence: true
  validates :email, uniqueness: true

  def phone=(value)
    write_attribute(:phone, value.gsub(/[^\d+x]/, ""))
  end

  def name
    format('%s %s', self.first_name, self.last_name)
  end
end
