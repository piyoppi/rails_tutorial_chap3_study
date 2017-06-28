require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest

  test "invalid signup information" do
    get signup_path
    assert_no_difference 'User.count' do
      post signup_path, params: {
        user: 
        {
          name: "",
          email: "user@invalid",
          password: "foo",
          password_confirmation: "bar"
        }
      }
    end

    assert_template 'users/new'

    # Check error messages
    assert_select 'li', "Email is invalid"
    assert_select 'li', "Name can't be blank"
    assert_select 'li', "Password confirmation doesn't match Password"
    assert_select 'li', "Password is too short (minimum is #{User::MIN_PASSWORD_LENGTH} characters)"

    assert_select 'form[action=?]', "/signup"

  end
end
