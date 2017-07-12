require 'test_helper'

class Api::AuthControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:michael)
  end

  test "login with invalid information" do
    post api_login_path, params: {email: "", password: ""}
    user = assigns(:user)
    assert user.nil?
  end

  test "login with valid information" do
    post api_login_path, params: {email: @user.email, password: "password"}
    user = assigns(:user)
    assert_not user.nil?
  end

end
