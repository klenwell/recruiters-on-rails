require 'test_helper'

class BlacklistTest < ActiveSupport::TestCase

  test "should blacklist and unblacklist a user" do
    blacklist = Blacklist.create!(recruiter_id: recruiters(:bob).id,
                                  color: 'black',
                                  reason: 'testing',
                                  active: true)
    assert recruiters(:bob).blacklisted?, 'should be blacklisted'

    blacklist.active = false
    blacklist.save!
    assert_not recruiters(:bob).blacklisted?, 'should not be blacklisted'
  end

  test "should require recruiter" do
    blacklist = Blacklist.new(color: 'black', reason: 'testing')
    assert_invalid_record_field(blacklist, 'recruiter_id')

    blacklist.recruiter_id = recruiters(:bob).id
    assert blacklist.valid?
  end

  test "should require color" do
    blacklist = Blacklist.new(recruiter_id: recruiters(:bob).id, reason: 'testing')
    assert_invalid_record_field(blacklist, 'color')

    blacklist.color = 'black'
    assert blacklist.valid?
  end

  test "that blacklist color is valid" do
    blacklist = Blacklist.new(recruiter_id: recruiters(:alice).id,
                              color: 'gray',
                              reason: 'testing',
                              active: true)
    assert blacklist.valid?, blacklist.errors.messages

    blacklist.color = 'black'
    assert blacklist.valid?, blacklist.errors.messages

    blacklist.color = 'green'
    assert_not blacklist.valid?, 'Blacklists cannot be green.'
  end

  test "should set active field to true by default" do
    blacklist = Blacklist.new(recruiter_id: recruiters(:bob).id,
                              reason: 'testing',
                              color: 'black')
    assert blacklist.active.nil?
    assert_not blacklist.active
    assert_not blacklist.active?

    blacklist.save!
    assert blacklist.active
    assert blacklist.active?
  end

  test "that recruiter can only be blacklisted once" do
    blacklist = Blacklist.create!(recruiter_id: recruiters(:bob).id,
                                  color: 'black',
                                  reason: 'testing')
    assert recruiters(:bob).blacklisted?, 'should be blacklisted'

    blacklist = Blacklist.new(recruiter_id: recruiters(:bob).id,
                              reason: 'testing',
                              color: 'black')
    assert_invalid_record_field(blacklist, :color, 'already blacklisted')
  end

  test "that recruiter can only be graylisted once" do
    graylist = Blacklist.create!(recruiter_id: recruiters(:alice).id,
                                 color: 'gray',
                                 reason: 'testing')
    assert recruiters(:alice).graylisted?, 'should be graylisted'

    graylist = Blacklist.new(recruiter_id: recruiters(:alice).id,
                             color: 'gray',
                             reason: 'testing')
    assert_invalid_record_field(graylist, :color, 'already graylisted')
  end
end
