require 'test_helper'

class IndexerLocationsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @indexer_location = indexer_locations(:one)
  end

  test "should get index" do
    get indexer_locations_url
    assert_response :success
  end

  test "should get new" do
    get new_indexer_location_url
    assert_response :success
  end

  test "should create indexer_location" do
    assert_difference('IndexerLocation.count') do
      post indexer_locations_url, params: { indexer_location: { domain: @indexer_location.domain, href: @indexer_location.href, indexer_status: @indexer_location.indexer_status, indexer_timestamp: @indexer_location.indexer_timestamp, ip: @indexer_location.ip, loc_link: @indexer_location.loc_link, msg: @indexer_location.msg, root: @indexer_location.root, sfdc_acct: @indexer_location.sfdc_acct, sfdc_city: @indexer_location.sfdc_city, sfdc_group_name: @indexer_location.sfdc_group_name, sfdc_id: @indexer_location.sfdc_id, sfdc_sales_person: @indexer_location.sfdc_sales_person, sfdc_state: @indexer_location.sfdc_state, sfdc_street: @indexer_location.sfdc_street, sfdc_tier: @indexer_location.sfdc_tier, sfdc_type: @indexer_location.sfdc_type, sfdc_ult_acct: @indexer_location.sfdc_ult_acct, text: @indexer_location.text } }
    end

    assert_redirected_to indexer_location_url(IndexerLocation.last)
  end

  test "should show indexer_location" do
    get indexer_location_url(@indexer_location)
    assert_response :success
  end

  test "should get edit" do
    get edit_indexer_location_url(@indexer_location)
    assert_response :success
  end

  test "should update indexer_location" do
    patch indexer_location_url(@indexer_location), params: { indexer_location: { domain: @indexer_location.domain, href: @indexer_location.href, indexer_status: @indexer_location.indexer_status, indexer_timestamp: @indexer_location.indexer_timestamp, ip: @indexer_location.ip, loc_link: @indexer_location.loc_link, msg: @indexer_location.msg, root: @indexer_location.root, sfdc_acct: @indexer_location.sfdc_acct, sfdc_city: @indexer_location.sfdc_city, sfdc_group_name: @indexer_location.sfdc_group_name, sfdc_id: @indexer_location.sfdc_id, sfdc_sales_person: @indexer_location.sfdc_sales_person, sfdc_state: @indexer_location.sfdc_state, sfdc_street: @indexer_location.sfdc_street, sfdc_tier: @indexer_location.sfdc_tier, sfdc_type: @indexer_location.sfdc_type, sfdc_ult_acct: @indexer_location.sfdc_ult_acct, text: @indexer_location.text } }
    assert_redirected_to indexer_location_url(@indexer_location)
  end

  test "should destroy indexer_location" do
    assert_difference('IndexerLocation.count', -1) do
      delete indexer_location_url(@indexer_location)
    end

    assert_redirected_to indexer_locations_url
  end
end
