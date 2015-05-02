class Merit < ActiveRecord::Base

  belongs_to :recruiter

  # Scopes
  scope :by_date, ->{ order 'date DESC' }

  def value
    self[:value].nil? ? 0 : self[:value]
  end

  def is_demerit?
    value < 0
  end

  def kind
    is_demerit? ? 'demerit' : 'merit'
  end

end