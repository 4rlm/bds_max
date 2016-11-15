require 'test_helper'

class GcsesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @gcse = gcses(:one)
  end

  test "should get index" do
    get gcses_url
    assert_response :success
  end

  test "should get new" do
    get new_gcse_url
    assert_response :success
  end

  test "should create gcse" do
    assert_difference('Gcse.count') do
      post gcses_url, params: { gcse: { domain: @gcse.domain, domain_status: @gcse.domain_status, exclude_root: @gcse.exclude_root, gcse_query_num: @gcse.gcse_query_num, gcse_result_num: @gcse.gcse_result_num, gcse_timestamp: @gcse.gcse_timestamp, in_host_del: @gcse.in_host_del, in_host_neg: @gcse.in_host_neg, in_host_pos: @gcse.in_host_pos, in_suffix_del: @gcse.in_suffix_del, in_text_del: @gcse.in_text_del, in_text_neg: @gcse.in_text_neg, in_text_pos: @gcse.in_text_pos, root: @gcse.root, sfdc_acct: @gcse.sfdc_acct, sfdc_city: @gcse.sfdc_city, sfdc_id: @gcse.sfdc_id, sfdc_state: @gcse.sfdc_state, sfdc_street: @gcse.sfdc_street, sfdc_type: @gcse.sfdc_type, sfdc_ult_acct: @gcse.sfdc_ult_acct, sfdc_url_o: @gcse.sfdc_url_o, suffix: @gcse.suffix, text: @gcse.text, url_encoded: @gcse.url_encoded } }
    end

    assert_redirected_to gcse_url(Gcse.last)
  end

  test "should show gcse" do
    get gcse_url(@gcse)
    assert_response :success
  end

  test "should get edit" do
    get edit_gcse_url(@gcse)
    assert_response :success
  end

  test "should update gcse" do
    patch gcse_url(@gcse), params: { gcse: { domain: @gcse.domain, domain_status: @gcse.domain_status, exclude_root: @gcse.exclude_root, gcse_query_num: @gcse.gcse_query_num, gcse_result_num: @gcse.gcse_result_num, gcse_timestamp: @gcse.gcse_timestamp, in_host_del: @gcse.in_host_del, in_host_neg: @gcse.in_host_neg, in_host_pos: @gcse.in_host_pos, in_suffix_del: @gcse.in_suffix_del, in_text_del: @gcse.in_text_del, in_text_neg: @gcse.in_text_neg, in_text_pos: @gcse.in_text_pos, root: @gcse.root, sfdc_acct: @gcse.sfdc_acct, sfdc_city: @gcse.sfdc_city, sfdc_id: @gcse.sfdc_id, sfdc_state: @gcse.sfdc_state, sfdc_street: @gcse.sfdc_street, sfdc_type: @gcse.sfdc_type, sfdc_ult_acct: @gcse.sfdc_ult_acct, sfdc_url_o: @gcse.sfdc_url_o, suffix: @gcse.suffix, text: @gcse.text, url_encoded: @gcse.url_encoded } }
    assert_redirected_to gcse_url(@gcse)
  end

  test "should destroy gcse" do
    assert_difference('Gcse.count', -1) do
      delete gcse_url(@gcse)
    end

    assert_redirected_to gcses_url
  end
end
