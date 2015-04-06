class Ping < ActiveRecord::Base

  # Constants
  KINDS = {
    # type: value
    # recruiter pinging you
    spam: 0,
    email: 1,
    phone_call: 1,

    # you pinging recruiter
    email_out: 0,
    phone_out: -1
  }

  # Validators
  validates :kind, inclusion: { in: KINDS.stringify_keys.keys,
    message: "%{value} is not a valid ping type" }

  # Class Methods
  def self.kinds
    KINDS.stringify_keys.keys
  end
end
