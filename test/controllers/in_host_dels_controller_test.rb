require 'test_helper'

class InHostDelsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @in_host_del = in_host_dels(:one)
  end

  test "should get index" do
    get in_host_dels_url
    assert_response :success
  end

  test "should get new" do
    get new_in_host_del_url
    assert_response :success
  end

  test "should create in_host_del" do
    assert_difference('InHostDel.count') do
      post in_host_dels_url, params: { in_host_del: { term: @in_host_del.term } }
    end

    assert_redirected_to in_host_del_url(InHostDel.last)
  end

  test "should show in_host_del" do
    get in_host_del_url(@in_host_del)
    assert_response :success
  end

  test "should get edit" do
    get edit_in_host_del_url(@in_host_del)
    assert_response :success
  end

  test "should update in_host_del" do
    patch in_host_del_url(@in_host_del), params: { in_host_del: { term: @in_host_del.term } }
    assert_redirected_to in_host_del_url(@in_host_del)
  end

  test "should destroy in_host_del" do
    assert_difference('InHostDel.count', -1) do
      delete in_host_del_url(@in_host_del)
    end

    assert_redirected_to in_host_dels_url
  end
end
