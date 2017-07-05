require 'test_helper'

class MicropostsInterfaceTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:michael)
  end

  test "check existing micropost user-interface" do
    log_in_as(@user)
    get root_path
    assert_select 'div.pagination'
    assert_select 'input[type=file]'
  end

  test "delete micropost" do
    #投稿を削除
    log_in_as(@user)
    get root_path
    assert_select 'a', text: 'delete'
    first_micropost = @user.microposts.paginate(page: 1).first
    assert_difference 'Micropost.count', -1 do
      delete micropost_path(first_micropost)
    end
  end


  test "valid post of micropost" do
    #有効な送信
    log_in_as(@user)
    get root_path
    content = "This micropost thes the room together"
    picture = fixture_file_upload('test/fixtures/rails.png', 'image/png')
    assert_difference 'Micropost.count', 1 do
      post microposts_path, params: {micropost: {content: content, picture: picture}}
    end
    assert assigns(:micropost).picture?
    assert_redirected_to root_url
    follow_redirect!
    assert_match content, response.body
  end


  test "invalid post of micropost" do
    #無効な送信
    log_in_as(@user)
    get root_path
    assert_no_difference 'Micropost.count' do
      post microposts_path, params: {micropost: {count: ""}}
    end
    assert_select 'div#error_explanation'
  end

  test "not exists delete link while other user is logined" do
    #違うユーザーのプロフィールにアクセスして削除リンクがないことを確認
    log_in_as(@user)
    get user_path(users(:archer))
    assert_select 'a', text: 'delete', count: 0
  end

  test "micropost sidebar count" do
    log_in_as(@user)
    get root_path
    assert_match "#{@user.microposts.count} microposts", response.body
    other_user = users(:malory)
    log_in_as(other_user)
    get root_path
    assert_match "0 microposts", response.body
    other_user.microposts.create!(content: "A micropost")
    get root_path
    assert_match "1 micropost", response.body
  end

end

