require 'test_helper'

class MicropostTest < ActiveSupport::TestCase
  def setup
    @user = users(:gai)
    # this is hard coding but will generalize it later
    # for now, making the test to pass
    @micropost = Micropost.new(content: "new post", user_id: @user.id)
  end

  test "should be valid" do
    assert @micropost.valid?  # test passes if argument returns true
  end

  test "user id should be present row" do
    @micropost.user_id = nil
    # we haven't imposed on any restriction, so the micropost will always be valid
    assert_not @micropost.valid? # test passes if argument returns false
  end

  test "micropost content should be present" do
    @micropost.content = "      "
    assert_not @micropost.valid?  # passes if argument returns false
  end

  test "micropost content should not be longer than 140 characters" do
    @micropost.content = "1" * 141
    assert_not @micropost.valid?  # passes if argument returns false
  end


end
