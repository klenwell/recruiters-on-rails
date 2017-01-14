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
    assert_equal '18005551212', john.phone
    assert_equal '200', john.phone_extension
  end

  test "that new recruiters score is 0" do
    homer = Recruiter.new(first_name: 'Homer', email: 'homer@recruiters.net')
    assert homer.score.nil?

    homer.save!
    assert_equal 0, homer.score
  end

  test "expects recruiter to be scored" do
    # Assume
    alice = recruiters(:alice)
    ping_interview_points = 10    # 3 (for each ping) + 7 (for interview)

    # Act
    2.times do |n|
      alice.pings << Ping.new(recruiter_id: alice.id, kind: 'email', note: 'test',
        date: Date.today)
      alice.save!
    end

    # Assert
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

  test "should blacklist recruiter" do
    bob = recruiters(:bob)
    blacklist = bob.blacklist({ color: 'black', reason: 'testing' })

    assert blacklist.persisted?, 'Blacklist record should have been created.'
    assert Recruiter.find(bob.id).blacklisted?, 'Recruiter should now be blacklisted'
  end

  test "should not blacklist recruiter when blacklist params are invalid" do
    # Invalid blacklist: missing required reason
    bob = recruiters(:bob)
    blacklist = bob.blacklist('')

    assert_not blacklist.persisted?, 'Blacklist record should not have been created.'
    assert_not Recruiter.find(bob.id).blacklisted?, 'Recruiter should not be blacklisted'
    assert_equal 1, blacklist.errors.full_messages.length
    assert_equal "Reason can't be blank", blacklist.errors.full_messages.first
  end

  test "that recruiter loses points when blacklisted and unblacklisted" do
    bob = recruiters(:bob)
    bob.save!   # Update score

    assert_difference('bob.score', -20) do
      bob.blacklist({ color: 'black', reason: 'testing' })
      bob.unblacklist
    end
  end

  test "that user will have no more than one associated blacklist" do
    alice = recruiters(:alice)
    alice.save!   # Update score
    Blacklist.destroy_all

    # Should lose 120 total
    assert_difference('Recruiter.find_by_id(alice.id).score', -120) do
      assert_difference('Merit.count', +3) do
        # Blacklist user: creates blacklist
        assert_difference('Blacklist.count', +1) do
          alice.blacklist('testing')
          assert alice.blacklisted?
        end

        # Unblacklist user: blacklist status changed
        assert_no_difference('Blacklist.count') do
          alice.unblacklist
          assert_not alice.blacklisted?
        end

        # Reblacklist user: blacklist status changed
        assert_no_difference('Blacklist.count') do
          alice.blacklist('re-blacklisting')
          assert alice.blacklisted?
        end
      end
    end
  end
end
