require 'test_helper'

class MeritsControllerTest < ActionController::TestCase
  setup do
    @merit = merits(:merit)
  end

  test "should get new" do
    get :new, recruiter_id: @merit.recruiter_id
    assert_response :success
  end
end
