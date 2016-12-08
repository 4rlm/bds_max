require 'test_helper'

class IndexerStaffsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @indexer_staff = indexer_staffs(:one)
  end

  test "should get index" do
    get indexer_staffs_url
    assert_response :success
  end

  test "should get new" do
    get new_indexer_staff_url
    assert_response :success
  end

  test "should create indexer_staff" do
    assert_difference('IndexerStaff.count') do
      post indexer_staffs_url, params: { indexer_staff: { domain: @indexer_staff.domain, href: @indexer_staff.href, indexer_status: @indexer_staff.indexer_status, indexer_timestamp: @indexer_staff.indexer_timestamp, ip: @indexer_staff.ip, msg: @indexer_staff.msg, root: @indexer_staff.root, sfdc_acct: @indexer_staff.sfdc_acct, sfdc_city: @indexer_staff.sfdc_city, sfdc_group_name: @indexer_staff.sfdc_group_name, sfdc_id: @indexer_staff.sfdc_id, sfdc_sales_person: @indexer_staff.sfdc_sales_person, sfdc_state: @indexer_staff.sfdc_state, sfdc_street: @indexer_staff.sfdc_street, sfdc_tier: @indexer_staff.sfdc_tier, sfdc_type: @indexer_staff.sfdc_type, sfdc_ult_acct: @indexer_staff.sfdc_ult_acct, staff_link: @indexer_staff.staff_link, text: @indexer_staff.text } }
    end

    assert_redirected_to indexer_staff_url(IndexerStaff.last)
  end

  test "should show indexer_staff" do
    get indexer_staff_url(@indexer_staff)
    assert_response :success
  end

  test "should get edit" do
    get edit_indexer_staff_url(@indexer_staff)
    assert_response :success
  end

  test "should update indexer_staff" do
    patch indexer_staff_url(@indexer_staff), params: { indexer_staff: { domain: @indexer_staff.domain, href: @indexer_staff.href, indexer_status: @indexer_staff.indexer_status, indexer_timestamp: @indexer_staff.indexer_timestamp, ip: @indexer_staff.ip, msg: @indexer_staff.msg, root: @indexer_staff.root, sfdc_acct: @indexer_staff.sfdc_acct, sfdc_city: @indexer_staff.sfdc_city, sfdc_group_name: @indexer_staff.sfdc_group_name, sfdc_id: @indexer_staff.sfdc_id, sfdc_sales_person: @indexer_staff.sfdc_sales_person, sfdc_state: @indexer_staff.sfdc_state, sfdc_street: @indexer_staff.sfdc_street, sfdc_tier: @indexer_staff.sfdc_tier, sfdc_type: @indexer_staff.sfdc_type, sfdc_ult_acct: @indexer_staff.sfdc_ult_acct, staff_link: @indexer_staff.staff_link, text: @indexer_staff.text } }
    assert_redirected_to indexer_staff_url(@indexer_staff)
  end

  test "should destroy indexer_staff" do
    assert_difference('IndexerStaff.count', -1) do
      delete indexer_staff_url(@indexer_staff)
    end

    assert_redirected_to indexer_staffs_url
  end
end
