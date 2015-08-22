class Interview < ActiveRecord::Base
  # Associations
  belongs_to :recruiter
  accepts_nested_attributes_for :recruiter

  # Constants
  Assessments = [:culture, :people, :work, :career, :commute, :salary, :gut]
  Kinds = ['phone', 'in-person']
  Results = ['waiting', 'advance', 'rejected', 'withdraw', 'offer']

  # Validations
  validates :company, :date, presence: true
  validates :culture, :people, :work, :career, :commute, :salary, :gut, inclusion: 1..5

  # Scopes
  scope :by_date, ->{ order('date DESC').includes(:recruiter) }

  # Public Methods
  def total
    [culture, people, work, career, commute, salary, gut].sum
  end

  def value
    total
  end

  def description
    format('Interview with %s at %s', interviewer.titleize, company.titleize)
  end

  def event
    self.class.to_s
  end
end
