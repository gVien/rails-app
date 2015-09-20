require 'test_helper'

class UserTest < ActiveSupport::TestCase
  # this method automatically gets run before each test
  def setup
    @user = User.new(name: "Test User", email: "user@example.com")
  end

  # is this a valid user? test
  # asset method succeeds if valid? method returns true, fails if it's false
  test "should be valid" do
    assert(@user.valid?)
  end

  # assert_not(object, message=nil)
  # returns true if object is nil or false
  # returns the error message if it is false (default to nil, which is falsy)
  # if object is true, then it's truthy
  test "should be invalid" do
    # blank name is considered not present in model
    @user.name = "   "
    # since @user.valid? is false, this returns true
    assert_not(@user.valid?)
  end

  test "email should be present" do
    @user.email = " "
    assert_not(@user.valid?)
  end
end
