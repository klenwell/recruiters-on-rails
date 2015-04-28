class Merit < ActiveRecord::Base

  belongs_to :recruiter

  # Scopes
  scope :by_date, ->{ order 'date DESC' }

end
