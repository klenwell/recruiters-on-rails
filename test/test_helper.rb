ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...
  def assert_invalid_record_field(record, field, message=nil)
    assert_not record.valid?

    unless message.nil?
      assert_not record.errors.to_hash[field].nil?, "Expected error #{field} not found"
      assert_equal record.errors.to_hash[field].first, message, 'Unexpected error message'
    end
  end

  def assert_not_select(selector, message)
    assert_select selector, false, message
  end
end
