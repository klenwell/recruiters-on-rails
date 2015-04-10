require 'test_helper'

class InterviewTest < ActiveSupport::TestCase
  test "should total assessment scores" do
    assert_equal 7, interviews(:acme).total
  end

  test "should create new interview" do
    interview = Interview.new(company: 'acme', date: Date.today)
    assert interview.valid?, interview.errors.messages
    assert interview.save
    assert_equal 7, interview.total
  end

  test "should require company field" do
    interview = Interview.new(date: Date.today)
    assert interview.invalid?
    assert interview.errors.keys.include?(:company), "Errors should include :company field"
  end

  test "should require date field" do
    interview = Interview.new(company: 'acme')
    assert interview.invalid?
    assert interview.errors.keys.include?(:date), "Errors should include :date field"
  end
end
