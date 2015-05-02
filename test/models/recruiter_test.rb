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

  test "should return all recruiter companies" do
    assert_equal recruiters(:alice).company, Recruiter.companies.first
  end

  test "should find company by email address" do
    assert_equal recruiters(:alice).company,
      Recruiter.find_existing_company_by_email(recruiters(:alice).email)
  end

  test "should sort by param" do
    sorted_recruiters = Recruiter.sorted('name', 'asc')
    assert_equal 'Alice', sorted_recruiters.first.first_name

    sorted_recruiters = Recruiter.sorted('name', 'desc')
    assert_equal 'Bob', sorted_recruiters.first.first_name
  end
end
