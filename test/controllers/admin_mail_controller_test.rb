require 'test_helper'

class AdminMailControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
  end

  test "should get send_to_access_level" do
    get :send_to_access_level
    assert_response :success
  end

  test "should get send_to_user" do
    get :send_to_user
    assert_response :success
  end

end
