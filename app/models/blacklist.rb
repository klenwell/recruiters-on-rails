class Blacklist < ActiveRecord::Base
  belongs_to :recruiter

  before_save :default_values

  # Constants
  Colors = ['black', 'gray']

  validates :recruiter, :color, presence: true
  validates :color, inclusion: { in: Colors }

  def active?
    return active
  end

  private

  def default_values
    self[:active] = true if self[:active].nil?
  end
end
