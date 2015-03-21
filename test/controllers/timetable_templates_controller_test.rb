require 'test_helper'

class TimetableTemplatesControllerTest < ActionController::TestCase
  setup do
    @timetable_template = timetable_templates(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:timetable_templates)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create timetable_template" do
    assert_difference('TimetableTemplate.count') do
      post :create, timetable_template: {  }
    end

    assert_redirected_to timetable_template_path(assigns(:timetable_template))
  end

  test "should show timetable_template" do
    get :show, id: @timetable_template
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @timetable_template
    assert_response :success
  end

  test "should update timetable_template" do
    patch :update, id: @timetable_template, timetable_template: {  }
    assert_redirected_to timetable_template_path(assigns(:timetable_template))
  end

  test "should destroy timetable_template" do
    assert_difference('TimetableTemplate.count', -1) do
      delete :destroy, id: @timetable_template
    end

    assert_redirected_to timetable_templates_path
  end
end
