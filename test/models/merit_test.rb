require 'test_helper'

class MeritTest < ActiveSupport::TestCase
  test "should create a merit" do
    merit = merits(:merit)
    assert merit.save, format("Failed to save merit: %s", merit.errors.full_messages)
    assert_equal +1, merit.value
  end

  test "should create a demerit" do
    demerit = merits(:demerit)
    assert demerit.save, format("Failed to save demerit: %s", demerit.errors.full_messages)
    assert_equal -1, demerit.value
  end

  test "should default value to 0" do
    merit = Merit.new
    assert_equal 0, merit.value
  end

  test "that is_demerit? method works" do
    assert merits(:demerit).is_demerit?
    assert_not merits(:merit).is_demerit?
  end
end
