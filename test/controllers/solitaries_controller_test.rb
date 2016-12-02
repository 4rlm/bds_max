require 'test_helper'

class SolitariesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @solitary = solitaries(:one)
  end

  test "should get index" do
    get solitaries_url
    assert_response :success
  end

  test "should get new" do
    get new_solitary_url
    assert_response :success
  end

  test "should create solitary" do
    assert_difference('Solitary.count') do
      post solitaries_url, params: { solitary: { solitary_root: @solitary.solitary_root, solitary_url: @solitary.solitary_url } }
    end

    assert_redirected_to solitary_url(Solitary.last)
  end

  test "should show solitary" do
    get solitary_url(@solitary)
    assert_response :success
  end

  test "should get edit" do
    get edit_solitary_url(@solitary)
    assert_response :success
  end

  test "should update solitary" do
    patch solitary_url(@solitary), params: { solitary: { solitary_root: @solitary.solitary_root, solitary_url: @solitary.solitary_url } }
    assert_redirected_to solitary_url(@solitary)
  end

  test "should destroy solitary" do
    assert_difference('Solitary.count', -1) do
      delete solitary_url(@solitary)
    end

    assert_redirected_to solitaries_url
  end
end
