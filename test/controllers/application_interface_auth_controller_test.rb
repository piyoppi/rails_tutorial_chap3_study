require 'test_helper'

class ApplicationInterfaceAuthControllerTest < ActionDispatch::IntegrationTest
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
    assert_not user.api_digest.nil?
  end

  test "logout with valid information" do
    log_in_as_api(@user)
    delete api_logout_path, headers: { 'Authorization' => @user.reload.api_digest }
    assert @user.reload.api_digest.nil?
  end

  test "logout with invalid token" do
    log_in_as_api(@user)
    delete api_logout_path, headers: { 'Authorization' => 'invalid'}
    assert_not @user.reload.api_digest.nil?
  end

end
