require 'test_helper'

class UserPageTestTest < ActionDispatch::IntegrationTest

  def setup
    @active_user = users(:michael)
    @nonactive_user = users(:nonactivate)
  end

  test "Showing user page" do
    get user_path(@active_user)
    assert_template 'users/show'

    get user_path(@nonactive_user)
    assert_redirected_to root_url
  end
end
