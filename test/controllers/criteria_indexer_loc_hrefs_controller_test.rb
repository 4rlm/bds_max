require 'test_helper'

class CriteriaIndexerLocHrefsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @criteria_indexer_loc_href = criteria_indexer_loc_hrefs(:one)
  end

  test "should get index" do
    get criteria_indexer_loc_hrefs_url
    assert_response :success
  end

  test "should get new" do
    get new_criteria_indexer_loc_href_url
    assert_response :success
  end

  test "should create criteria_indexer_loc_href" do
    assert_difference('CriteriaIndexerLocHref.count') do
      post criteria_indexer_loc_hrefs_url, params: { criteria_indexer_loc_href: { term: @criteria_indexer_loc_href.term } }
    end

    assert_redirected_to criteria_indexer_loc_href_url(CriteriaIndexerLocHref.last)
  end

  test "should show criteria_indexer_loc_href" do
    get criteria_indexer_loc_href_url(@criteria_indexer_loc_href)
    assert_response :success
  end

  test "should get edit" do
    get edit_criteria_indexer_loc_href_url(@criteria_indexer_loc_href)
    assert_response :success
  end

  test "should update criteria_indexer_loc_href" do
    patch criteria_indexer_loc_href_url(@criteria_indexer_loc_href), params: { criteria_indexer_loc_href: { term: @criteria_indexer_loc_href.term } }
    assert_redirected_to criteria_indexer_loc_href_url(@criteria_indexer_loc_href)
  end

  test "should destroy criteria_indexer_loc_href" do
    assert_difference('CriteriaIndexerLocHref.count', -1) do
      delete criteria_indexer_loc_href_url(@criteria_indexer_loc_href)
    end

    assert_redirected_to criteria_indexer_loc_hrefs_url
  end
end
