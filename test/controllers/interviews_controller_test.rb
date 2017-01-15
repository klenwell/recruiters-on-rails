require 'test_helper'

class InterviewsControllerTest < ActionController::TestCase
  setup do
    @interview = interviews(:acme)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:interviews)
  end

  test "expects new interview form" do
    get :new
    assert_response :success
  end

  test "expects new interview with recruiter pre-assigned" do
    # Assume
    recruiter = recruiters(:alice)
    interview_selector = 'select#interview_recruiter_id option[selected]'

    # Act
    get :new, recruiter_id: recruiter.id
    selected_recruiter_id = assert_select(interview_selector, {count: 1}).first['value']

    # Assert
    assert_response :success
    assert_equal(selected_recruiter_id, recruiter.id.to_s)
  end

  test "should create interview with recruiter assigned" do
    assert_difference('Interview.count') do
      post :create,
        interview: {
          career: @interview.career,
          commute: @interview.commute,
          company: @interview.company,
          culture: @interview.culture,
          date: @interview.date,
          gut: @interview.gut,
          people: @interview.people,
          salary: @interview.salary,
          work: @interview.work,
          recruiter_id: @interview.recruiter_id
        }
    end

    assert assigns(:interview)
    assert_redirected_to interviews_path

    created_interview = Interview.find(assigns(:interview).id)
    assert_equal Recruiter.find(@interview.recruiter_id), created_interview.recruiter
  end

  test "should show interview" do
    get :show, id: @interview
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @interview, recruiter_id: @interview.recruiter_id
    assert_response :success
  end

  test "should update interview" do
    patch :update, id: @interview, interview: { career: @interview.career,
      commute: @interview.commute, company: @interview.company, culture: @interview.culture,
      date: @interview.date, gut: @interview.gut, people: @interview.people,
      recruiter_id: @interview.recruiter_id, salary: @interview.salary, work: @interview.work }

    assert assigns(:interview)
    assert_redirected_to interviews_path
  end

  test "should destroy interview" do
    assert_difference('Interview.count', -1) do
      delete :destroy, id: @interview
    end

    assert_redirected_to interviews_path
  end
end
