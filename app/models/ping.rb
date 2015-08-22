class Ping < ActiveRecord::Base
  include InTimeline

  belongs_to :recruiter

  # Constants
  Kinds = {
    # type: value
    # recruiter pinging you
    'spam' => 0,
    'email' => 1,
    'phone call' => 1,
    'meeting' => 3,

    # you pinging recruiter
    'email from you' => 0,
    'phone call from you' => -1,
  }

  Events = {
    'mailchimp import' => 0
  }

  # Validators
  validates :kind, inclusion: { in: Kinds.keys + Events.keys,
    message: "%{value} is not a valid ping type" }

  # Scopes
  scope :by_date, ->{ order 'date DESC' }

  # Class Methods
  def self.kinds
    Kinds.stringify_keys.keys
  end

  # Instance Methods
  def value
    Kinds.merge(Events).fetch(kind, 0)
  end

  def description
    format('[%s] %s', kind.capitalize, note)
  end
end
