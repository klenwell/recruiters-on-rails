class Interview < ActiveRecord::Base
  include Scorable
  include InTimeline

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
  scope :by_date, ->{ order('date DESC') }

  # Public Methods
  def value
    ratings_total = [culture, people, work, career, commute, salary, gut].sum
    status_factor = case result
      when 'rejected' then 0.5
      when 'withdraw' then 0.75
      when 'advance' then 1.5
      when 'offer' then 2.0
      else 1.0
    end
    (ratings_total * status_factor).round
  end

  def description
    format('Interview with %s at %s', interviewer.titleize, company.titleize)
  end
end
