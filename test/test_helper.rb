ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require "minitest/reporters"
Minitest::Reporters.use!

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all
  include ApplicationHelper

  def is_logged_in?
    !session[:user_id].nil?
  end

  # テストユーザーとしてログイン
  def log_in_as(user)
    session[:user_id] = user.id
  end
end

class ActionDispatch::IntegrationTest
  # テストユーザーとしてログインする
  def log_in_as(user, password: 'password', remember_me: '1')
    post login_path, params: { session: { email: user.email,
                                          password: password,
                                          remember_me: remember_me } }
  end

  def log_in_as_api(user)
    post api_login_path, params: {email: @user.email, password: "password"}
    return json_response
  end

  def submit_reset_password(user)
    post password_resets_path, params: {password_reset: {email: user.email}}
    assigns(:user)
  end

  def json_response
     ActiveSupport::JSON.decode @response.body
  end
end
