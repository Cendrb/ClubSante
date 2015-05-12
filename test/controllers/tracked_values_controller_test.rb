require 'test_helper'

class TrackedValuesControllerTest < ActionController::TestCase
  setup do
    @tracked_value = tracked_values(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:tracked_values)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create tracked_value" do
    assert_difference('TrackedValue.count') do
      post :create, tracked_value: { available_value_id: @tracked_value.available_value_id, user_id: @tracked_value.user_id }
    end

    assert_redirected_to tracked_value_path(assigns(:tracked_value))
  end

  test "should show tracked_value" do
    get :show, id: @tracked_value
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @tracked_value
    assert_response :success
  end

  test "should update tracked_value" do
    patch :update, id: @tracked_value, tracked_value: { available_value_id: @tracked_value.available_value_id, user_id: @tracked_value.user_id }
    assert_redirected_to tracked_value_path(assigns(:tracked_value))
  end

  test "should destroy tracked_value" do
    assert_difference('TrackedValue.count', -1) do
      delete :destroy, id: @tracked_value
    end

    assert_redirected_to tracked_values_path
  end
end
