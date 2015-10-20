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

  # define users
  # TTD for following user, check if user is being followed (following?), and unfollow user
  test "should follow and unfollow user" do
    gai = users(:gai)
    kathy = users(:kathy)
    assert_not gai.following?(kathy) # check if gai is following kathy, to pass, should be false initially
    gai.follow(kathy)  #now gai follows kathy
    assert gai.following?(kathy)  #check again, which should returns true to pass
    gai.unfollow(kathy)  #gai unfollow kathy
    assert_not gai.following?(kathy) #gai should not follow kathy
  end
end
