require 'test_helper'

class PingTest < ActiveSupport::TestCase
  test "should create a spam ping" do
    spam_ping = pings(:recruiter_spam)
    assert spam_ping.save, format("Failed to save ping: %s", spam_ping.errors.full_messages)
    assert_equal 'spam', spam_ping.kind
  end

  test "should not create ping with invalid kind" do
    ping = Ping.new(pings(:recruiter_spam).attributes.except('id').merge({'kind'=>'fubar'}))
    assert_not ping.valid?
    assert ping.errors.to_hash.include?(:kind),
      format("kind field should be invalid: %s", ping.errors.to_hash)
  end
end
