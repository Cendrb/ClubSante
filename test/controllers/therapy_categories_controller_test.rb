require 'test_helper'

class TherapyCategoriesControllerTest < ActionController::TestCase
  setup do
    @therapy_category = therapy_categories(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:therapy_categories)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create therapy_category" do
    assert_difference('TherapyCategory.count') do
      post :create, therapy_category: { name: @therapy_category.name }
    end

    assert_redirected_to therapy_category_path(assigns(:therapy_category))
  end

  test "should show therapy_category" do
    get :show, id: @therapy_category
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @therapy_category
    assert_response :success
  end

  test "should update therapy_category" do
    patch :update, id: @therapy_category, therapy_category: { name: @therapy_category.name }
    assert_redirected_to therapy_category_path(assigns(:therapy_category))
  end

  test "should destroy therapy_category" do
    assert_difference('TherapyCategory.count', -1) do
      delete :destroy, id: @therapy_category
    end

    assert_redirected_to therapy_categories_path
  end
end
