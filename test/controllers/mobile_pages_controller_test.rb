require 'test_helper'

class MobilePagesControllerTest < ActionDispatch::IntegrationTest
  test "should get home" do
    get mobile_pages_home_url
    assert_response :success
  end

end
