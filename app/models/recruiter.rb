class Recruiter < ActiveRecord::Base

  validates :first_name, :email, presence: true
  validates :email, uniqueness: true

  def phone=(value)
    write_attribute(:phone, value.gsub(/[^\d+x]/, ""))
  end
end
