require 'test_helper'

class GlobalSettingsControllerTest < ActionController::TestCase
  test "should get pass_form" do
    get :pass_form
    assert_response :success
  end

  test "should get pass_set" do
    get :pass_set
    assert_response :success
  end

end
