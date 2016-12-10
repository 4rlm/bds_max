require 'test_helper'

class PendingVerificationsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @pending_verification = pending_verifications(:one)
  end

  test "should get index" do
    get pending_verifications_url
    assert_response :success
  end

  test "should get new" do
    get new_pending_verification_url
    assert_response :success
  end

  test "should create pending_verification" do
    assert_difference('PendingVerification.count') do
      post pending_verifications_url, params: { pending_verification: { domain: @pending_verification.domain, root: @pending_verification.root } }
    end

    assert_redirected_to pending_verification_url(PendingVerification.last)
  end

  test "should show pending_verification" do
    get pending_verification_url(@pending_verification)
    assert_response :success
  end

  test "should get edit" do
    get edit_pending_verification_url(@pending_verification)
    assert_response :success
  end

  test "should update pending_verification" do
    patch pending_verification_url(@pending_verification), params: { pending_verification: { domain: @pending_verification.domain, root: @pending_verification.root } }
    assert_redirected_to pending_verification_url(@pending_verification)
  end

  test "should destroy pending_verification" do
    assert_difference('PendingVerification.count', -1) do
      delete pending_verification_url(@pending_verification)
    end

    assert_redirected_to pending_verifications_url
  end
end
