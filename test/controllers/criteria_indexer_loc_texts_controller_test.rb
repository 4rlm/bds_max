require 'test_helper'

class CriteriaIndexerLocTextsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @criteria_indexer_loc_text = criteria_indexer_loc_texts(:one)
  end

  test "should get index" do
    get criteria_indexer_loc_texts_url
    assert_response :success
  end

  test "should get new" do
    get new_criteria_indexer_loc_text_url
    assert_response :success
  end

  test "should create criteria_indexer_loc_text" do
    assert_difference('CriteriaIndexerLocText.count') do
      post criteria_indexer_loc_texts_url, params: { criteria_indexer_loc_text: { term: @criteria_indexer_loc_text.term } }
    end

    assert_redirected_to criteria_indexer_loc_text_url(CriteriaIndexerLocText.last)
  end

  test "should show criteria_indexer_loc_text" do
    get criteria_indexer_loc_text_url(@criteria_indexer_loc_text)
    assert_response :success
  end

  test "should get edit" do
    get edit_criteria_indexer_loc_text_url(@criteria_indexer_loc_text)
    assert_response :success
  end

  test "should update criteria_indexer_loc_text" do
    patch criteria_indexer_loc_text_url(@criteria_indexer_loc_text), params: { criteria_indexer_loc_text: { term: @criteria_indexer_loc_text.term } }
    assert_redirected_to criteria_indexer_loc_text_url(@criteria_indexer_loc_text)
  end

  test "should destroy criteria_indexer_loc_text" do
    assert_difference('CriteriaIndexerLocText.count', -1) do
      delete criteria_indexer_loc_text_url(@criteria_indexer_loc_text)
    end

    assert_redirected_to criteria_indexer_loc_texts_url
  end
end
