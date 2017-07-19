require 'test_helper'

class UsersProfileTest < ActionDispatch::IntegrationTest
  include ApplicationHelper

  def setup
    @user = users(:michael)
  end

  test "profile display" do
    get user_path(@user)
    assert_template 'users/show'
    assert_select 'title', full_title(@user.name)
    assert_select 'h1', text: @user.name
    assert_select 'h1>img.gravatar'
    assert_match @user.microposts.count.to_s, response.body
    assert_select 'div.pagination', count: 1
    @user.microposts.paginate(page: 1).each do |micropost|
      assert_match micropost.content, response.body
    end
  end

  test "the number of following and followers" do
    get user_path(@user)
    assert_select 'strong#following', text: @user.following.count.to_s
    assert_select 'strong#followers', text: @user.followers.count.to_s
  end

  test "getting any following-users from api" do
    login_response = log_in_as_api(@user)
    get "/api/#{following_user_path @user}", headers: {'Authorization' => login_response["access_token"]}
    assert_response 200
    @user.following.limit(10).offset(0).each do |user|
      assert json_response["users"].to_s.include? user.name
    end
  end

  test "getting any followers from api" do
    login_response = log_in_as_api(@user)
    get "/api/#{followers_user_path @user}", headers: {'Authorization' => login_response["access_token"]}
    assert_response 200
    @user.followers.limit(10).offset(0).each do |user|
      assert json_response["users"].to_s.include? user.name
    end
  end

end
