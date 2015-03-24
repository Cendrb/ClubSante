require 'test_helper'

class ExerciseTemplatesControllerTest < ActionController::TestCase
  setup do
    @exercise_template = exercise_templates(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:exercise_templates)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create exercise_template" do
    assert_difference('ExerciseTemplate.count') do
      post :create, exercise_template: {  }
    end

    assert_redirected_to exercise_template_path(assigns(:exercise_template))
  end

  test "should show exercise_template" do
    get :show, id: @exercise_template
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @exercise_template
    assert_response :success
  end

  test "should update exercise_template" do
    patch :update, id: @exercise_template, exercise_template: {  }
    assert_redirected_to exercise_template_path(assigns(:exercise_template))
  end

  test "should destroy exercise_template" do
    assert_difference('ExerciseTemplate.count', -1) do
      delete :destroy, id: @exercise_template
    end

    assert_redirected_to exercise_templates_path
  end
end
