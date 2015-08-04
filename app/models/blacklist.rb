class Blacklist < ActiveRecord::Base
  belongs_to :recruiter
  accepts_nested_attributes_for :recruiter

  before_save :default_values

  Colors = ['black', 'gray']
  Demerits = { 'black' => -100, 'gray' => -50 }

  validates :recruiter, :color, :reason, presence: true
  validates :color, inclusion: { in: Colors }
  validates :color, uniqueness: {scope: :recruiter, message: "already %{value}listed"}

  scope :indexed, -> { where(active: true).order('created_at DESC') }

  def active?
    active
  end

  def demerit_value
    Demerits[color]
  end

  private

  def default_values
    self[:active] = true if self[:active].nil?
  end
end
