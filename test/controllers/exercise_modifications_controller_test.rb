require 'test_helper'

class ExerciseModificationsControllerTest < ActionController::TestCase
  setup do
    @exercise_modification = exercise_modifications(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:exercise_modifications)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create exercise_modification" do
    assert_difference('ExerciseModification.count') do
      post :create, exercise_modification: { coach_id: @exercise_modification.coach_id, date: @exercise_modification.date, exercise_template_id: @exercise_modification.exercise_template_id, note: @exercise_modification.note, price: @exercise_modification.price, timetable_template_id: @exercise_modification.timetable_template_id }
    end

    assert_redirected_to exercise_modification_path(assigns(:exercise_modification))
  end

  test "should show exercise_modification" do
    get :show, id: @exercise_modification
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @exercise_modification
    assert_response :success
  end

  test "should update exercise_modification" do
    patch :update, id: @exercise_modification, exercise_modification: { coach_id: @exercise_modification.coach_id, date: @exercise_modification.date, exercise_template_id: @exercise_modification.exercise_template_id, note: @exercise_modification.note, price: @exercise_modification.price, timetable_template_id: @exercise_modification.timetable_template_id }
    assert_redirected_to exercise_modification_path(assigns(:exercise_modification))
  end

  test "should destroy exercise_modification" do
    assert_difference('ExerciseModification.count', -1) do
      delete :destroy, id: @exercise_modification
    end

    assert_redirected_to exercise_modifications_path
  end
end
