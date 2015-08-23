ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'


# Enable Bullet
# https://github.com/flyerhzm/bullet#run-in-tests
# http://stufftohelpyouout.blogspot.com/2014/03/using-bullet-with-minitest-and.html
module MiniTestUsesBullet
  def before_setup
    Bullet.start_request
    super if defined?(super)
  end

  def after_teardown
    super if defined?(super)
    Bullet.end_request
  end
end


class ActiveSupport::TestCase
  include MiniTestUsesBullet if Bullet.enable?

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
