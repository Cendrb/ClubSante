require 'test_helper'

class NavigationControllerTest < ActionController::TestCase
  test "should get summary" do
    get :summary
    assert_response :success
  end

  test "should get reservations" do
    get :reservations
    assert_response :success
  end

  test "should get tickets" do
    get :tickets
    assert_response :success
  end

  test "should get goals" do
    get :goals
    assert_response :success
  end

  test "should get administration" do
    get :administration
    assert_response :success
  end

end
