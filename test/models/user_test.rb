require 'test_helper'

class UserTest < ActiveSupport::TestCase
  # this method automatically gets run before each test
  def setup
    @user = User.new(name: "Test User", email: "user@example.com", password: "password", password_confirmation: "password")
  end

  # is this a valid user? test
  # asset method succeeds if valid? method returns true, fails if it's false
  test "should be valid" do
    assert(@user.valid?, "User should be valid")
  end

  # assert_not(object, message=nil)
  # returns true if object is nil or false
  # if object is true, then it's truthy and it returns a statement "expect <object> to be nil or false" (can also have a custom message)
  test "should be invalid" do
    # blank name is considered not present in model
    @user.name = "   "
    # since @user.valid? is true, it returns a message expecting that @user.valid? to be nil or false (which means the test results in an error if the model does not have a validation that name is present -- to make @user.valid? return false)
    assert_not(@user.valid?)
  end

  test "email should be present" do
    @user.email = " "
    assert_not(@user.valid?)
  end

  test "name should not be more than 50 characters" do
    @user.name = "z" * 51
    # @user.valid returns true if the model does not restrict to less than or equal to 50 characters. The assert_not expects a false or nil value
    assert_not(@user.valid?, "Name should not be longer than 50 characters")
  end

  test "email should not be more than 255 characters" do
    @user.email = "z" * 244 + "@example.com"
    assert_not(@user.valid?, "Email should not be longer than 255 characters")
  end

  test "email validation should accept valid addresses format" do
    valid_addresses = %w[user@example.com USER@example2.com E_w-Q@one.two.edu first.last@company.tw hello+there@b.ru]

    valid_addresses.each do |valid_address|
      @user.email = valid_address
      # returns true if @user.valid is true
      # if false and returns the message per the element
      assert(@user.valid?, "#{valid_address.inspect} should be valid format")
    end
  end

  test "email validation should reject invalid addresses format" do
    invalid_addresses = %w[user@example,com user_at_foo.org user.name@example.
                           foo@bar_baz.com foo@bar+baz.com]
    invalid_addresses.each do |invalid_address|
      @user.email = invalid_address
      # all @user.valid? will return true which assert_not is not expecting (it expects false or nil)
      # Returns the message if @user.valid? true
      # add regexp in model solves this, since all these emails are not valid (returns false)
      assert_not(@user.valid?, "#{invalid_address.inspect} should be invalid")
    end
  end

  test "email address should be unique" do
    duplicate_user = @user.dup
    duplicate_user.email = @user.email.upcase
    @user.save
    assert_not(duplicate_user.valid?, "#{duplicate_user.email} should be unique")
  end

  # exercise 6.1 to test email downcase
  test "email addresses should be saved as lower-case" do
    mixed_case_email = "mIxEd@CaSe.CoM"
    @user.email = mixed_case_email
    @user.save
    assert_equal(mixed_case_email.downcase, @user.reload.email)
  end

  test "password should be present (cannot be blank" do
    @user.password = @user.password_confirmation = " " * 6
    # if @user.valid? is true, then it will display the message
    assert_not(@user.valid?, "Password should be present (non-blank)")
  end

  test "password should have a minimum length of 6" do
    @user.password = @user.password_confirmation = "a" * 5
    assert_not(@user.valid?, "password must be at least 6 characters long")
  end

  # this test tries to replicate a scenario when a user use two different browsers to log into the sites
  test "authenticated? should return false for a user with nil digest" do
    # the pass passes if the argument returns false (when the token is not equal to the remember digest)
    # the setup method initially does not have a remember digest, so this will be false
    # we need to update the authenticated? method to return false if remember_digest is nil
    # (otherwise the test will give us an error, since the digest does not exist in the set up method
    # -- multiple browsers "bug" if one browser window logs out while the other isn't)
    assert_not(@user.authenticated?(:remember, ""))
  end

  test "associated microposts should be destroyed if the user who posted is destroyed" do
    @user.save
    # create a microposts
    @user.microposts.create(content: "this post will get destroyed if the user is")
    # length of all of Micropost should be 1 less after @user is destroyed
    assert_difference "Micropost.all.length", -1 do   #or "Micropost.count"
      @user.destroy
    end
  end

  # status feed test
  test "should have the right posts from self, followed users" do
    # see relationship fixture
    gai = users(:gai) # follows new_user, followed by user2
    new_user = users(:new_user) #follows user2, followed by gai
    user2 = users(:user2) #follows gai, followed by new_user

    # gai should see all of new users posts (followed user)
    new_user.microposts.each do |post_new_user|
      assert gai.feed.include?(post_new_user), "must see the following user's microposts"
    end

    # gai should not see any of kath's post (unfollow user)
    user2.microposts.each do |user2_post|
      assert_not gai.feed.include?(user2_post)
    end

    # gai should see his posts
    gai.microposts.each do |my_post|
      assert gai.feed.include?(my_post)
    end
  end
end
