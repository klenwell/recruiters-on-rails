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

  test "should search and sort recruiters" do
    get :index, {recruiter_search: {name_like: 'inc'}, sort_by: 'email', sort_in: 'desc'}
    assert_response :success
    assert_select 'tr.recruiter', {count: 2}
    assert_select 'tr.recruiter:nth-of-type(1) td:nth-of-type(1)', {text: 'Bob Banana'}
  end

  test "should provide link to new recruiter view when searching email and result is empty" do
    get :index, {recruiter_search: {name_like: 'does.not.exist@noop.org'}}
    assert_response :success
    assert_select 'td.no-records', {count: 1}
    assert_select 'td.no-records a', {text: 'Click here'}
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

    alice = Recruiter.find_by_email("alice@gmail.com")
    assert_redirected_to new_recruiter_ping_path(alice)
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
    patch :update, id: @recruiter, recruiter: { company: @recruiter.company,
      email: @recruiter.email, first_name: @recruiter.first_name,
      last_name: @recruiter.last_name, phone: @recruiter.phone }
    assert_redirected_to recruiters_path
  end

  test "should destroy recruiter" do
    assert_difference('Recruiter.count', -1) do
      delete :destroy, id: @recruiter
    end

    assert_redirected_to recruiters_path
  end

  test "should import unzipped test MailChimp export file" do
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

  test "should import zipped test MailChimp export file" do
    assert_difference('Recruiter.count', 2) do
      post :process_import, file: fixture_file_upload('files/members_export_0d46a7760f.zip')
    end
    assert_redirected_to recruiters_path

    # Verify import data
    recruiter_email = 'alice.apple@noop.org'
    alice = Recruiter.find_by_email(recruiter_email)
    assert_equal recruiter_email, alice.email
  end

  test "should display error when import form is submitted with empty file field" do
    post :process_import
    assert_redirected_to import_recruiters_path
    assert_equal 'Please choose a file.', flash[:error]
  end

  test "should add recruiter to list" do
    new_list = recruiter_lists(:vegetable)
    assert_not_equal new_list.id, @recruiter.recruiter_list_id

    patch :update, id: @recruiter, recruiter: { recruiter_list_id: new_list.id }
    assert_redirected_to recruiters_path
    assert_equal new_list.id, assigns(:recruiter).recruiter_list_id
  end

  test "should export recruiters to csv" do
    get :index, {recruiter_search: {name_like: 'inc'}, sort_by: 'email', sort_in: 'desc',
      format: 'csv'}
    assert_response :success

    csv = CSV.parse(@response.body)

    assert_equal 'first_name', csv.first.first
    assert_equal 'list', csv.first.last
    assert_equal 'Bob', csv[1].first
    assert_equal 'Alice', csv[2].first
    assert_equal 'Fruit', csv[2].last
    assert_equal Recruiter::CSV_PING_MARKER, csv[3].first
    assert_equal 'spam', csv[3][5]
    assert_equal Recruiter::CSV_MERIT_MARKER, csv[4].first
    assert_equal 'A test merit', csv[4][8]
  end

  test "should export all recruiters to csv" do
    get :export, {format: 'csv'}
    assert_response :success

    csv = CSV.parse(@response.body)
    assert_equal 'first_name', csv.first.first
    assert_equal 'score', csv.first[-2]
    assert_equal 'list', csv.first.last

    assert_equal 'Alice', csv[1].first
    assert_equal '7', csv[1][-2]
    assert_equal 'Fruit', csv[1].last

    assert_equal 'Bob', csv.last.first
    assert_equal '0', csv.last[-2]
    assert_equal 'Fruit', csv.last.last
  end

  test "should export all recruiters to csv and then re-import them" do
    get :export, {format: 'csv'}
    assert_response :success

    temp_file = Tempfile.new('import')
    temp_file.write @response.body
    temp_file.rewind
    temp_file.close

    import_file = ActionDispatch::Http::UploadedFile.new({
      :filename => temp_file.path.split('/').last,
      :content_type => 'text/csv',
      :tempfile => temp_file
    })

    Recruiter.destroy_all

    assert_difference('Recruiter.count', 2) do
      assert_difference('Ping.count', 3) do
        assert_difference('Merit.count', 2) do
          post :process_import, file: import_file
          assert_redirected_to recruiters_path
          assert_equal 2, Recruiter.find_by_first_name('Alice').pings.count
          assert_equal 2, Recruiter.find_by_first_name('Alice').merits.count
        end
      end
    end

    temp_file.unlink
  end

  test "should show unblacklist button with recruiter is blacklisted" do
    blacklist = Blacklist.create!(recruiter_id: @recruiter.id,
                                  reason: 'testing',
                                  color: 'black',
                                  active: true)

    get :edit, id: @recruiter
    assert_response :success
    assert_select 'button.btn.unblacklist', 1, 'Should show unblacklist button'
    assert_select 'button.btn.ungraylist', false, 'Should not show ungraylist button'
    assert_select 'button.btn.blacklist', false, 'Should not show blacklist button'
    assert_select 'button.btn.graylist', 1, 'Should show graylist button'
  end

  test "should unblacklist recruiter" do
    Blacklist.destroy_all

    bob = recruiters(:bob)
    bob.blacklist('testing')
    assert bob.blacklisted?

    xhr :post, :unblacklist, id: bob, color: 'black'
    assert_response :success
    assert_equal "text/javascript", @response.content_type
    assert_not bob.blacklisted?
  end

  test "should ungraylist recruiter" do
    Blacklist.destroy_all

    bob = recruiters(:bob)
    bob.graylist('testing')
    assert bob.graylisted?

    xhr :post, :unblacklist, id: bob, color: 'gray'
    assert_response :success
    assert_equal "text/javascript", @response.content_type
    assert_not bob.graylisted?
  end
end
