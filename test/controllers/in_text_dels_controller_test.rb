require 'test_helper'

class InTextDelsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @in_text_del = in_text_dels(:one)
  end

  test "should get index" do
    get in_text_dels_url
    assert_response :success
  end

  test "should get new" do
    get new_in_text_del_url
    assert_response :success
  end

  test "should create in_text_del" do
    assert_difference('InTextDel.count') do
      post in_text_dels_url, params: { in_text_del: { term: @in_text_del.term } }
    end

    assert_redirected_to in_text_del_url(InTextDel.last)
  end

  test "should show in_text_del" do
    get in_text_del_url(@in_text_del)
    assert_response :success
  end

  test "should get edit" do
    get edit_in_text_del_url(@in_text_del)
    assert_response :success
  end

  test "should update in_text_del" do
    patch in_text_del_url(@in_text_del), params: { in_text_del: { term: @in_text_del.term } }
    assert_redirected_to in_text_del_url(@in_text_del)
  end

  test "should destroy in_text_del" do
    assert_difference('InTextDel.count', -1) do
      delete in_text_del_url(@in_text_del)
    end

    assert_redirected_to in_text_dels_url
  end
end
