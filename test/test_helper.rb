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
      assert_equal record.errors.to_hash[field].first, message, 'Unexpected error message'
    end
  end
end
