class RecruiterList < ActiveRecord::Base
  has_many :recruiters

  validates :name, presence: true
  validates :name, uniqueness: true
end
