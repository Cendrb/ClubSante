require 'test_helper'

class TimetableModificationsControllerTest < ActionController::TestCase
  setup do
    @timetable_modification = timetable_modifications(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:timetable_modifications)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create timetable_modification" do
    assert_difference('TimetableModification.count') do
      post :create, timetable_modification: { calendar_id: @timetable_modification.calendar_id }
    end

    assert_redirected_to timetable_modification_path(assigns(:timetable_modification))
  end

  test "should show timetable_modification" do
    get :show, id: @timetable_modification
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @timetable_modification
    assert_response :success
  end

  test "should update timetable_modification" do
    patch :update, id: @timetable_modification, timetable_modification: { calendar_id: @timetable_modification.calendar_id }
    assert_redirected_to timetable_modification_path(assigns(:timetable_modification))
  end

  test "should destroy timetable_modification" do
    assert_difference('TimetableModification.count', -1) do
      delete :destroy, id: @timetable_modification
    end

    assert_redirected_to timetable_modifications_path
  end
end
