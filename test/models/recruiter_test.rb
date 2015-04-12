require 'test_helper'

class RecruiterTest < ActiveSupport::TestCase

  test "should require first name and email" do
    # First name
    john = Recruiter.new(recruiters(:alice).attributes.except('first_name')
      .merge({'email'=>'john@recruiters.inc'}))
    assert_not john.valid?
    assert john.errors.to_hash.include?(:first_name),
      format("first_name field should be required: %s", john.errors.to_hash)

    # Email
    john = Recruiter.new(recruiters(:alice).attributes.except('email'))
    assert_not john.valid?
    assert john.errors.to_hash.include?(:email),
      format("email field should be required: %s", john.errors.to_hash)
  end

  test "that phone number is normalized" do
    john = Recruiter.new(recruiters(:alice).attributes.except('id').merge({
      'phone'=>'1-800-555-1212 x200', 'email'=>'john@recruiters.inc'}))
    assert_equal '18005551212x200', john.phone
  end

  test "that recruiters are scored" do
    alice = recruiters(:alice)

    2.times do |n|
      alice.pings << Ping.new(recruiter_id: alice.id, kind: 'email', note: 'test',
                              date: Date.today)
      alice.save!
    end

    ping_interview_points = 9   # 2 (for each ping) + 7 (for interview)
    assert_equal ping_interview_points, alice.score
  end
end
