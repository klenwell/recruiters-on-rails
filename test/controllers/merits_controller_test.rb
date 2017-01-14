require 'test_helper'

class MeritsControllerTest < ActionController::TestCase
  setup do
    @merit = merits(:merit)
  end

  test "should get new merit" do
    get :new, recruiter_id: @merit.recruiter_id
    assert_response :success
  end

  test "expects merit to be created and recruiter score to be updated" do
    # Assume
    @merit.recruiter.save!
    assert_not_nil @merit.recruiter.score

    # Act / Assert
    assert_difference('Merit.count') do
      assert_difference('@merit.recruiter.score', @merit.value) do
        post :create, recruiter_id: @merit.recruiter_id,
          merit: { date: @merit.date, reason: @merit.reason, value: @merit.value }
      end
    end

    assert assigns(:merit)
    assert_redirected_to edit_recruiter_path(id: @merit.recruiter_id)
  end

  test "should get edit view" do
    get :edit, id: @merit, recruiter_id: @merit.recruiter_id
    assert_response :success
  end

  test "should update merit" do
    patch :update, id: @merit, recruiter_id: @merit.recruiter_id,
      merit: { date: @merit.date, reason: @merit.reason, value: @merit.value }
    assert_redirected_to edit_recruiter_path(id: @merit.recruiter_id)
  end

  test "should destroy ping" do
    assert_difference('Merit.count', -1) do
      delete :destroy, id: @merit, recruiter_id: @merit.recruiter_id
    end

    assert_redirected_to recruiters_path
  end
end
