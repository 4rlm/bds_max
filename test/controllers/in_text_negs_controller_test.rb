require 'test_helper'

class InTextNegsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @in_text_neg = in_text_negs(:one)
  end

  test "should get index" do
    get in_text_negs_url
    assert_response :success
  end

  test "should get new" do
    get new_in_text_neg_url
    assert_response :success
  end

  test "should create in_text_neg" do
    assert_difference('InTextNeg.count') do
      post in_text_negs_url, params: { in_text_neg: { term: @in_text_neg.term } }
    end

    assert_redirected_to in_text_neg_url(InTextNeg.last)
  end

  test "should show in_text_neg" do
    get in_text_neg_url(@in_text_neg)
    assert_response :success
  end

  test "should get edit" do
    get edit_in_text_neg_url(@in_text_neg)
    assert_response :success
  end

  test "should update in_text_neg" do
    patch in_text_neg_url(@in_text_neg), params: { in_text_neg: { term: @in_text_neg.term } }
    assert_redirected_to in_text_neg_url(@in_text_neg)
  end

  test "should destroy in_text_neg" do
    assert_difference('InTextNeg.count', -1) do
      delete in_text_neg_url(@in_text_neg)
    end

    assert_redirected_to in_text_negs_url
  end
end
