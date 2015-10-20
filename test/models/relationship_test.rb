require 'test_helper'

class RelationshipTest < ActiveSupport::TestCase

  def setup
    @relationship = Relationship.new(follower_id: 1, followed_id: 2)
  end

  # test shoud be valid
  # test should have follower id
  # test should have followed id
  test "should be valid" do
    assert @relationship.valid? #pass if true
  end

  test "should have follower id" do
    @relationship.follower_id = ""
    assert_not @relationship.valid?  #pass if this is false (since it's not valid)
  end

  test "should have followed id" do
    @relationship.followed_id = ""
    assert_not @relationship.valid? #pass if this is false (since it's not valid)
  end
end
