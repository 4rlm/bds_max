require 'test_helper'

class CriteriaIndexerStaffTextsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @criteria_indexer_staff_text = criteria_indexer_staff_texts(:one)
  end

  test "should get index" do
    get criteria_indexer_staff_texts_url
    assert_response :success
  end

  test "should get new" do
    get new_criteria_indexer_staff_text_url
    assert_response :success
  end

  test "should create criteria_indexer_staff_text" do
    assert_difference('CriteriaIndexerStaffText.count') do
      post criteria_indexer_staff_texts_url, params: { criteria_indexer_staff_text: { term: @criteria_indexer_staff_text.term } }
    end

    assert_redirected_to criteria_indexer_staff_text_url(CriteriaIndexerStaffText.last)
  end

  test "should show criteria_indexer_staff_text" do
    get criteria_indexer_staff_text_url(@criteria_indexer_staff_text)
    assert_response :success
  end

  test "should get edit" do
    get edit_criteria_indexer_staff_text_url(@criteria_indexer_staff_text)
    assert_response :success
  end

  test "should update criteria_indexer_staff_text" do
    patch criteria_indexer_staff_text_url(@criteria_indexer_staff_text), params: { criteria_indexer_staff_text: { term: @criteria_indexer_staff_text.term } }
    assert_redirected_to criteria_indexer_staff_text_url(@criteria_indexer_staff_text)
  end

  test "should destroy criteria_indexer_staff_text" do
    assert_difference('CriteriaIndexerStaffText.count', -1) do
      delete criteria_indexer_staff_text_url(@criteria_indexer_staff_text)
    end

    assert_redirected_to criteria_indexer_staff_texts_url
  end
end
