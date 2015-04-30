class Merit < ActiveRecord::Base

  belongs_to :recruiter

  # Scopes
  scope :by_date, ->{ order 'date DESC' }

  def is_demerit?
    value < 0
  end

end
