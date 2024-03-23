require "test_helper"

class InquiriesControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get inquiries_new_url
    assert_response :success
  end

  test "should get create" do
    get inquiries_create_url
    assert_response :success
  end
end
