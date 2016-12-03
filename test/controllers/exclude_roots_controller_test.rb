require 'test_helper'

class ExcludeRootsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @exclude_root = exclude_roots(:one)
  end

  test "should get index" do
    get exclude_roots_url
    assert_response :success
  end

  test "should get new" do
    get new_exclude_root_url
    assert_response :success
  end

  test "should create exclude_root" do
    assert_difference('ExcludeRoot.count') do
      post exclude_roots_url, params: { exclude_root: { term: @exclude_root.term } }
    end

    assert_redirected_to exclude_root_url(ExcludeRoot.last)
  end

  test "should show exclude_root" do
    get exclude_root_url(@exclude_root)
    assert_response :success
  end

  test "should get edit" do
    get edit_exclude_root_url(@exclude_root)
    assert_response :success
  end

  test "should update exclude_root" do
    patch exclude_root_url(@exclude_root), params: { exclude_root: { term: @exclude_root.term } }
    assert_redirected_to exclude_root_url(@exclude_root)
  end

  test "should destroy exclude_root" do
    assert_difference('ExcludeRoot.count', -1) do
      delete exclude_root_url(@exclude_root)
    end

    assert_redirected_to exclude_roots_url
  end
end
