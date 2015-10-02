require 'test_helper'

class UsersEditTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:gai)
  end

  # we will test the unsuccessful edit
  # 1. visit the edit path
  # 2. verify that the new sessions form renders properly
  # 3. patch (update) the user
  # 4. verify that the template is still there (since it's an unsuccessful edit)
  test "unsuccessful edit of user" do
    get edit_user_path @user
    assert_template("users/edit") # from users folder
    patch user_path(@user), user: { name: "gai",
                                    email: "gai@example.com"
                                    password: "123",
                                    password_confirmation: "1" }
    assert_template("users/edit")
  end
end
