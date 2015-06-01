require 'test_helper'

class RecruiterListsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:lists)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create list" do
    assert_difference('RecruiterList.count') do
      post :create, recruiter_list: { name: 'Trees' }
    end

    assert_redirected_to recruiter_lists_path
  end

  test "should get edit" do
    get :edit, id: recruiter_lists(:fruit)
    assert_response :success
  end

  test "should update list" do
    patch :update, id: recruiter_lists(:fruit),
      recruiter_list: { name: 'Minerals' }
    assert_redirected_to recruiter_lists_path
  end
end
