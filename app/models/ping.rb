class Ping < ActiveRecord::Base

  belongs_to :recruiter

  # Constants
  KINDS = {
    # type: value
    # recruiter pinging you
    'spam' => 0,
    'email' => 1,
    'phone call' => 1,
    'meeting' => 3,

    # you pinging recruiter
    'email from you' => 0,
    'phone call from you' => -1
  }

  # Validators
  validates :kind, inclusion: { in: KINDS.stringify_keys.keys,
    message: "%{value} is not a valid ping type" }

  # Scopes
  scope :by_date, ->{ order 'date DESC' }

  # Class Methods
  def self.kinds
    KINDS.stringify_keys.keys
  end

  def value
    KINDS[kind]
  end
end
