require 'test_helper'

class FeedTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:michael)
  end

  test "getting feed with login" do
    log_in_as(@user)
    get api_feed_index_path, headers: {'Authorization' => @user.reload.api_digest}, params: {page: 0}
    @user.feed.limit(10).offset(0).each do |micropost|
      assert json_response["feed"].to_s.include? micropost.content
      assert json_response["feed"].to_s.include? micropost.user_id.to_s
    end
  end

  test "getting feed with non-login" do
    get api_feed_index_path, headers: {'Authorization' => @user.reload.api_digest}, params: {page: 0}
    assert json_response["feed"].nil?
    assert json_response["users"].nil?
  end

  test "getting feed with invalid token" do
    get api_feed_index_path, headers: {'Authorization' => 'invalid_token'}, params: {page: 0}
    assert json_response["feed"].nil?
    assert json_response["users"].nil?
  end

end
