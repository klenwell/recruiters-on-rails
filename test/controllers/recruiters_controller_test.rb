require 'test_helper'

class RecruitersControllerTest < ActionController::TestCase
  setup do
    @recruiter = recruiters(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:recruiters)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create recruiter" do
    assert_difference('Recruiter.count') do
      post :create, recruiter: { company: @recruiter.company, email: @recruiter.email, first_name: @recruiter.first_name, last_name: @recruiter.last_name, phone: @recruiter.phone }
    end

    assert_redirected_to recruiter_path(assigns(:recruiter))
  end

  test "should show recruiter" do
    get :show, id: @recruiter
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @recruiter
    assert_response :success
  end

  test "should update recruiter" do
    patch :update, id: @recruiter, recruiter: { company: @recruiter.company, email: @recruiter.email, first_name: @recruiter.first_name, last_name: @recruiter.last_name, phone: @recruiter.phone }
    assert_redirected_to recruiter_path(assigns(:recruiter))
  end

  test "should destroy recruiter" do
    assert_difference('Recruiter.count', -1) do
      delete :destroy, id: @recruiter
    end

    assert_redirected_to recruiters_path
  end
end
