require 'test_helper'

class AvailableValuesControllerTest < ActionController::TestCase
  setup do
    @available_value = available_values(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:available_values)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create available_value" do
    assert_difference('AvailableValue.count') do
      post :create, available_value: { name: @available_value.name }
    end

    assert_redirected_to available_value_path(assigns(:available_value))
  end

  test "should show available_value" do
    get :show, id: @available_value
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @available_value
    assert_response :success
  end

  test "should update available_value" do
    patch :update, id: @available_value, available_value: { name: @available_value.name }
    assert_redirected_to available_value_path(assigns(:available_value))
  end

  test "should destroy available_value" do
    assert_difference('AvailableValue.count', -1) do
      delete :destroy, id: @available_value
    end

    assert_redirected_to available_values_path
  end
end
