require "test_helper"

class StripePaymentControllerTest < ActionDispatch::IntegrationTest
  test "should get initialize_payment" do
    get stripe_payment_initialize_payment_url
    assert_response :success
  end

  test "should get process_payment" do
    get stripe_payment_process_payment_url
    assert_response :success
  end

  test "should get apply_discount" do
    get stripe_payment_apply_discount_url
    assert_response :success
  end

  test "should get webhook" do
    get stripe_payment_webhook_url
    assert_response :success
  end

  test "should get success" do
    get stripe_payment_success_url
    assert_response :success
  end

  test "should get failure" do
    get stripe_payment_failure_url
    assert_response :success
  end
end
