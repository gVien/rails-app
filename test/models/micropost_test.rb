require 'test_helper'

class MicropostTest < ActiveSupport::TestCase
  def setup
    @user = users(:gai)
    # `build` is similar to `new` in the sense that it returns the object in memory (without id) without saving it in the database
    # use `save` method to save it
    @micropost = @user.microposts.build(content: "new post")
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

  test "order of microposts should be at the most recent first" do
    # p microposts(:micropost1) # returns the fixture micropost for `micropost1`
    # default order in Micropost is ASC.
    # need to reverse this with `default_scope` in micropost model (e.g. order DESC)
    # `default_scope` can be used to set up the default order of database (e.g. in this case, order("created_at DESC") in sql)
    # order(created_at: :desc) in Active Record
    assert_equal microposts(:most_recent), Micropost.first
  end

end
