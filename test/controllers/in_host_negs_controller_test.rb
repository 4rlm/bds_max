require 'test_helper'

class InHostNegsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @in_host_neg = in_host_negs(:one)
  end

  test "should get index" do
    get in_host_negs_url
    assert_response :success
  end

  test "should get new" do
    get new_in_host_neg_url
    assert_response :success
  end

  test "should create in_host_neg" do
    assert_difference('InHostNeg.count') do
      post in_host_negs_url, params: { in_host_neg: { term: @in_host_neg.term } }
    end

    assert_redirected_to in_host_neg_url(InHostNeg.last)
  end

  test "should show in_host_neg" do
    get in_host_neg_url(@in_host_neg)
    assert_response :success
  end

  test "should get edit" do
    get edit_in_host_neg_url(@in_host_neg)
    assert_response :success
  end

  test "should update in_host_neg" do
    patch in_host_neg_url(@in_host_neg), params: { in_host_neg: { term: @in_host_neg.term } }
    assert_redirected_to in_host_neg_url(@in_host_neg)
  end

  test "should destroy in_host_neg" do
    assert_difference('InHostNeg.count', -1) do
      delete in_host_neg_url(@in_host_neg)
    end

    assert_redirected_to in_host_negs_url
  end
end
