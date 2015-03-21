require 'test_helper'

class ExerciseDaysControllerTest < ActionController::TestCase
  setup do
    @exercise_day = exercise_days(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:exercise_days)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create exercise_day" do
    assert_difference('ExerciseDay.count') do
      post :create, exercise_day: { date: @exercise_day.date }
    end

    assert_redirected_to exercise_day_path(assigns(:exercise_day))
  end

  test "should show exercise_day" do
    get :show, id: @exercise_day
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @exercise_day
    assert_response :success
  end

  test "should update exercise_day" do
    patch :update, id: @exercise_day, exercise_day: { date: @exercise_day.date }
    assert_redirected_to exercise_day_path(assigns(:exercise_day))
  end

  test "should destroy exercise_day" do
    assert_difference('ExerciseDay.count', -1) do
      delete :destroy, id: @exercise_day
    end

    assert_redirected_to exercise_days_path
  end
end
