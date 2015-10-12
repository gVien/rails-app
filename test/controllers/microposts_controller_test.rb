require 'test_helper'

class MicropostsControllerTest < ActionController::TestCase

  def setup
    @micropost = microposts(:most_recent)
  end

  # 1. verify the count does not change when the user attempts to crate a micropost
  # 2. verify it redirects to login page
  test "should redirect create if user is not logged in" do
    assert_no_difference "Micropost.count" do
      post(:create, micropost: { content: "illegal micropost cannot be created "})
    end
    assert_redirected_to login_url
  end

  test "should redirect destroy if user is not logged in" do
    assert_no_difference "Micropost.count" do
      delete(:destroy, id: @micropost)
    end
    assert_redirected_to login_url
  end
end
