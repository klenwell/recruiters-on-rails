require 'test_helper'

class RecruiterSearchTest < ActiveSupport::TestCase

  test "typeahead search" do
    # No recruiters
    assert_equal 0, RecruiterSearch.new({typeahead: 'xx'}).results.count

    # Single recruiter
    assert_equal 1, RecruiterSearch.new({typeahead: 'alice'}).results.count

    # Multiple recruiters
    assert_equal 2, RecruiterSearch.new({typeahead: 'inc'}).results.count
  end

  test "name_like search" do
    # No recruiters
    assert_equal 0, RecruiterSearch.new({name_like: 'xx'}).results.count

    # Single recruiter
    assert_equal 1, RecruiterSearch.new({name_like: 'alice'}).results.count

    # Multiple recruiters
    assert_equal 2, RecruiterSearch.new({name_like: 'inc'}).results.count
  end
end
