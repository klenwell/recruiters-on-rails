class Interview < ActiveRecord::Base
  # Associations
  belongs_to :recruiter
  accepts_nested_attributes_for :recruiter

  # Constants
  Assessments = [:culture, :people, :work, :career, :commute, :salary, :gut]

  # Validations
  validates :company, :date, presence: true
  validates :culture, :people, :work, :career, :commute, :salary, :gut, inclusion: 1..5

  # Scopes
  scope :recent, ->{ order('DATE desc') }

  # Public Methods
  def total
    [culture, people, work, career, commute, salary, gut].sum
  end
end
