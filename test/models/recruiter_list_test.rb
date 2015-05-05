require 'test_helper'

class RecruiterListTest < ActiveSupport::TestCase
  test 'should return list members' do
    fruit_list = recruiter_lists(:fruit)
    assert_equal 2, fruit_list.recruiters.length
    assert fruit_list.recruiters.include? recruiters(:alice)
    assert fruit_list.recruiters.include? recruiters(:bob)
  end
end
