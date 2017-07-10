require 'test_helper'

class UsersIndexTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:michael)
    @non_admin = users(:archer)
  end

  test "index including pagination" do
    log_in_as(@user)
    get users_path
    assert_template 'users/index'
    assert_select 'div.pagination', count: 2
    User.where(activated: true).paginate(page: 1).each do |user|
      assert_select 'a[href=?]', user_path(user), text: user.name
    end
    assert_difference 'User.count', -1 do
      delete user_path(@non_admin)
    end
  end

  test "index as non-admin" do
    log_in_as(@non_admin)
    get users_path
    assert_select 'a', text: 'delete', count: 0
  end

  test "json as non-login" do
    log_in_as_api(@user)
    get "/api/#{users_path}", headers: {'Authorization' => 'invalid'}
    assert_equal json_response["message"], "Please log in."
  end

  test "json as login" do
    log_in_as_api(@user)
    get "/api/#{users_path}", headers: {'Authorization' => @user.reload.api_digest}
    assert_not_equal json_response["message"], "Please log in."
  end

end
