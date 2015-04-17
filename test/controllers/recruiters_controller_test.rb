require 'test_helper'

class RecruitersControllerTest < ActionController::TestCase
  setup do
    @recruiter = recruiters(:alice)
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
    recruiter_params = @recruiter.attributes.merge(email: "alice@gmail.com")

    assert_difference('Recruiter.count') do
      post :create, recruiter: recruiter_params
    end

    assert_redirected_to recruiters_path
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
    assert_redirected_to recruiters_path
  end

  test "should destroy recruiter" do
    assert_difference('Recruiter.count', -1) do
      delete :destroy, id: @recruiter
    end

    assert_redirected_to recruiters_path
  end

  test "should import test MailChimp export file" do
    assert_difference('Recruiter.count', 4) do
      post :process_import, file: fixture_file_upload('files/mailchimp-export.csv')
    end
    assert_redirected_to recruiters_path

    # Verify import data and normalizations
    recruiter_email = 'cheri.cherry@corp.company-three.com'
    cheri = Recruiter.find_by_email(recruiter_email)
    assert_equal recruiter_email, cheri.email
    assert_equal 'Company Three', cheri.company

    # Assert ping added
    assert_equal 1, cheri.pings.length
    assert_equal Date.today, cheri.pings.first.date
    assert_equal 'mailchimp import', cheri.pings.first.kind
    assert_equal Ping::Events['mailchimp import'], cheri.pings.first.value
  end

  test "should map MailChimp import to existing company by email" do
    @recruiter.update_attribute(:email, 'alice@company-two.com')

    assert_difference('Recruiter.count', 4) do
      post :process_import, file: fixture_file_upload('files/mailchimp-export.csv')
    end
    assert_redirected_to recruiters_path

    bob = Recruiter.find_by_email('bob.banana@company-two.com')
    assert_equal @recruiter.company, bob.company
  end
end
