require 'test_helper'

class InSuffixDelsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @in_suffix_del = in_suffix_dels(:one)
  end

  test "should get index" do
    get in_suffix_dels_url
    assert_response :success
  end

  test "should get new" do
    get new_in_suffix_del_url
    assert_response :success
  end

  test "should create in_suffix_del" do
    assert_difference('InSuffixDel.count') do
      post in_suffix_dels_url, params: { in_suffix_del: { term: @in_suffix_del.term } }
    end

    assert_redirected_to in_suffix_del_url(InSuffixDel.last)
  end

  test "should show in_suffix_del" do
    get in_suffix_del_url(@in_suffix_del)
    assert_response :success
  end

  test "should get edit" do
    get edit_in_suffix_del_url(@in_suffix_del)
    assert_response :success
  end

  test "should update in_suffix_del" do
    patch in_suffix_del_url(@in_suffix_del), params: { in_suffix_del: { term: @in_suffix_del.term } }
    assert_redirected_to in_suffix_del_url(@in_suffix_del)
  end

  test "should destroy in_suffix_del" do
    assert_difference('InSuffixDel.count', -1) do
      delete in_suffix_del_url(@in_suffix_del)
    end

    assert_redirected_to in_suffix_dels_url
  end
end
