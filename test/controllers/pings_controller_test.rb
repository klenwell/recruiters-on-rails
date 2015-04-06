require 'test_helper'

class PingsControllerTest < ActionController::TestCase
  setup do
    @ping = pings(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:pings)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create ping" do
    assert_difference('Ping.count') do
      post :create, ping: { date: @ping.date, kind: @ping.kind, note: @ping.note, recruiter: @ping.recruiter, transcript: @ping.transcript, value: @ping.value }
    end

    assert_redirected_to ping_path(assigns(:ping))
  end

  test "should show ping" do
    get :show, id: @ping
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @ping
    assert_response :success
  end

  test "should update ping" do
    patch :update, id: @ping, ping: { date: @ping.date, kind: @ping.kind, note: @ping.note, recruiter: @ping.recruiter, transcript: @ping.transcript, value: @ping.value }
    assert_redirected_to ping_path(assigns(:ping))
  end

  test "should destroy ping" do
    assert_difference('Ping.count', -1) do
      delete :destroy, id: @ping
    end

    assert_redirected_to pings_path
  end
end
