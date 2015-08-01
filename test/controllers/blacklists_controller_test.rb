require 'test_helper'

class BlacklistsControllerTest < ActionController::TestCase
  test "should create blacklist with recruiter assigned" do
    Blacklist.destroy_all

    blacklist_params = {
      color: 'gray',
      reason: "Guy's a schmuck."
    }
    recruiter_id = recruiters(:bob).id

    assert_difference('Blacklist.count', +1) do
      assert_difference('Merit.count', +1) do
        assert_difference('Recruiter.find_by_id(recruiter_id).score', -50) do
          post :create, blacklist: blacklist_params, recruiter_id: recruiter_id,
            format: :json
        end
      end
    end

    assert_response :success

    created_blacklist = Blacklist.last
    assert_equal Recruiter.find(recruiter_id), created_blacklist.recruiter
    assert created_blacklist.active?
    assert_equal 'gray', created_blacklist.color
  end

  test "should return an error and not create blacklist or demerit" do
    Blacklist.destroy_all

    blacklist_params = {
      color: 'green',
      reason: "Guy's a schmuck."
    }
    recruiter_id = recruiters(:bob).id

    assert_no_difference('Blacklist.count') do
      assert_no_difference('Merit.count') do
        assert_no_difference('Recruiter.find_by_id(recruiter_id).score') do
          post :create, blacklist: blacklist_params, recruiter_id: recruiter_id,
            format: :json
        end
      end
    end

    assert_response :unprocessable_entity
    assert JSON.parse(@response.body)['error'].starts_with?('Validation failed'),
      "Should have returned error message starting: 'Validation failed'."
  end
end
