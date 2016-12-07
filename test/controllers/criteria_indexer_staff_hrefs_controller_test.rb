require 'test_helper'

class CriteriaIndexerStaffHrefsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @criteria_indexer_staff_href = criteria_indexer_staff_hrefs(:one)
  end

  test "should get index" do
    get criteria_indexer_staff_hrefs_url
    assert_response :success
  end

  test "should get new" do
    get new_criteria_indexer_staff_href_url
    assert_response :success
  end

  test "should create criteria_indexer_staff_href" do
    assert_difference('CriteriaIndexerStaffHref.count') do
      post criteria_indexer_staff_hrefs_url, params: { criteria_indexer_staff_href: { term: @criteria_indexer_staff_href.term } }
    end

    assert_redirected_to criteria_indexer_staff_href_url(CriteriaIndexerStaffHref.last)
  end

  test "should show criteria_indexer_staff_href" do
    get criteria_indexer_staff_href_url(@criteria_indexer_staff_href)
    assert_response :success
  end

  test "should get edit" do
    get edit_criteria_indexer_staff_href_url(@criteria_indexer_staff_href)
    assert_response :success
  end

  test "should update criteria_indexer_staff_href" do
    patch criteria_indexer_staff_href_url(@criteria_indexer_staff_href), params: { criteria_indexer_staff_href: { term: @criteria_indexer_staff_href.term } }
    assert_redirected_to criteria_indexer_staff_href_url(@criteria_indexer_staff_href)
  end

  test "should destroy criteria_indexer_staff_href" do
    assert_difference('CriteriaIndexerStaffHref.count', -1) do
      delete criteria_indexer_staff_href_url(@criteria_indexer_staff_href)
    end

    assert_redirected_to criteria_indexer_staff_hrefs_url
  end
end
