require 'test_helper'

class PasswordResetsTest < ActionDispatch::IntegrationTest

  def setup
    ActionMailer::Base.deliveries.clear
    @user = users(:michael)
  end

  test "starting password reset" do
    #パスワードリセット要求送信テスト
    get new_password_reset_path
    assert_template 'password_resets/new'
    #メールアドレスが無効のとき
    post password_resets_path, params: {password_reset: {email: ""}}
    assert_not flash.empty?
    assert_template 'password_resets/new'
    #メールアドレスが有効のとき
    post password_resets_path, params: {password_reset: {email: @user.email}}
    assert_not_equal @user.reset_digest, @user.reload.reset_digest
    assert_equal 1, ActionMailer::Base.deliveries.size
    assert_not flash.empty?
    assert_redirected_to root_url
  end

  test "password-reset request is invalid" do
    #パスワード再設定フォームの要求テスト(要求が通らない条件)
    user = submit_reset_password(@user)
    #メールアドレスが無効のとき
    get edit_password_reset_path(user.reset_token, email: "")
    assert_redirected_to root_url
    #ユーザーが無効なとき
    user.toggle!(:activated)
    get edit_password_reset_path(user.reset_token, email: user.email)
    assert_redirected_to root_url
    user.toggle!(:activated)
    #メールアドレスが有効で、トークンが無効
    get edit_password_reset_path('wrong token', email: user.email)
    assert_redirected_to root_url
  end

  test "password-reset request is valid" do
    #パスワード再設定フォームの要求テスト(要求が通る条件)
    user = submit_reset_password(@user)
    get edit_password_reset_path(user.reset_token, email: user.email)
    assert_template 'password_resets/edit'
    assert_select "input[name=email][type=hidden][value=?]", user.email
  end

  test "password-reset is invalid" do
    #パスワード再設定テスト（要求が通らないとき）
    user = submit_reset_password(@user)
    #無効なパスワードとパスワード確認
    patch password_reset_path(user.reset_token), params: {
      email: user.email,
      user: {
        password: "foobaz",
        password_confirmation: "hogefuga"
      }
    }
    assert_select 'div#error_explanation'
    #パスワードが空
    patch password_reset_path(user.reset_token), params: {
      email: user.email,
      user: {
        password: "",
        password_confirmation: ""
      }
    }
    assert_select 'div#error_explanation'
  end

  test "password-reset is valid" do
    #有効なパスワード・パスワード確認
    user = submit_reset_password(@user)
    patch password_reset_path(user.reset_token), params: {
      email: user.email,
      user: {
        password: "foobaz",
        password_confirmation: "foobaz"
      }
    }
    assert is_logged_in?
    assert_nil user.reload.reset_digest
    assert_not flash.empty?
    assert_redirected_to user
  end

  test "expired token" do
    get new_password_reset_path
    user = submit_reset_password(@user)
    user.update_attribute(:reset_sent_at, 3.hours.ago)
    patch password_reset_path(user.reset_token), params: {
      email: user.email,
      user: {
        password: "foobar",
        password_confirmation: "foobar"
      }
    }
    assert_response :redirect
    follow_redirect!
    assert_match /expired/i, response.body
  end

end
