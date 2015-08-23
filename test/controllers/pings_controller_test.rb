require 'test_helper'

class PingsControllerTest < ActionController::TestCase
  setup do
    @ping = pings(:recruiter_spam)
  end

  test "should get index" do
    get :index, recruiter_id: @ping.recruiter_id
    assert_response :success
    assert_not_nil assigns(:pings)
  end

  test "should get new" do
    get :new, recruiter_id: @ping.recruiter_id
    assert_response :success
  end

  test "should create ping" do
    assert_difference('Ping.count') do
      post :create, recruiter_id: @ping.recruiter_id,
        ping: { date: @ping.date, kind: @ping.kind, note: @ping.note }
    end

    assert assigns(:ping)
    assert_redirected_to edit_recruiter_path(id: @ping.recruiter_id)
  end

  test "should show ping" do
    get :show, id: @ping, recruiter_id: @ping.recruiter_id
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @ping, recruiter_id: @ping.recruiter_id
    assert_response :success
  end

  test "should update ping" do
    patch :update, id: @ping, recruiter_id: @ping.recruiter_id,
      ping: { date: @ping.date, kind: @ping.kind, note: @ping.note }
    assert_redirected_to edit_recruiter_path(id: @ping.recruiter_id)
  end

  test "should destroy ping" do
    assert_difference('Ping.count', -1) do
      delete :destroy, id: @ping, recruiter_id: @ping.recruiter_id
    end

    assert_redirected_to edit_recruiter_path(id: @ping.recruiter_id)
  end
end
