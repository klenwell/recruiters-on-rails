class Blacklist < ActiveRecord::Base
  belongs_to :recruiter
  accepts_nested_attributes_for :recruiter

  before_save :default_values

  # Constants
  Colors = ['black', 'gray']
  Demerits = { 'black' => -100, 'gray' => -50 }

  validates :recruiter, :color, presence: true
  validates :color, inclusion: { in: Colors }

  def active?
    return active
  end

  def demerit_value
    Demerits[color]
  end

  private

  def default_values
    self[:active] = true if self[:active].nil?
  end
end
