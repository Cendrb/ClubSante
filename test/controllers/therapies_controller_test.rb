require 'test_helper'

class TherapiesControllerTest < ActionController::TestCase
  setup do
    @therapy = therapies(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:therapies)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create therapy" do
    assert_difference('Therapy.count') do
      post :create, therapy: { capacity: @therapy.capacity, length_in_minutes: @therapy.length_in_minutes, name: @therapy.name }
    end

    assert_redirected_to therapy_path(assigns(:therapy))
  end

  test "should show therapy" do
    get :show, id: @therapy
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @therapy
    assert_response :success
  end

  test "should update therapy" do
    patch :update, id: @therapy, therapy: { capacity: @therapy.capacity, length_in_minutes: @therapy.length_in_minutes, name: @therapy.name }
    assert_redirected_to therapy_path(assigns(:therapy))
  end

  test "should destroy therapy" do
    assert_difference('Therapy.count', -1) do
      delete :destroy, id: @therapy
    end

    assert_redirected_to therapies_path
  end
end
