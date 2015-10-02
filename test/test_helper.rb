ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all
  include ApplicationHelper

  # Add more helper methods to be used by all tests here...

  # this method is the same as logged_in?
  # but since helper methods are not available in tests (the application helper do not have the logged_in? method that we need)
  # returns true if a test users is logged in
  def is_logged_in?
    !session[:user_id].nil?
  end

  # test help method to log in a test user
  # this saves us time by not manually writing the the session hash
  # this method helps us log in the user to perform the integration test for the remember me feature
  # two tests will be done, one to make sure if the remember_me value is "1" (default) & another is when the value is "0" are both working
  # we will test to see if the cookie is nil or not but a better test is to chek if the user
  # has been remembered by looking for hte remember_token key in the cookies
  # we need to check if the cookie's value is equal to the user's remember token
  def log_in_as(user, options = {})
    # note the password must match with the users.yml in fixtures folder
    password = options[:password] || "123456" # a better way would be to use fetch
    remember_me = options[:remember_me] || "1"
    if integration_test?  # if it is integration test
      post login_path, session: { email: user.email,
                                  password: password,
                                  remember_me: remember_me }
    else  # if not integration test, set this
      session[:user_id] = user.id
    end
  end

  private
    # the defined method returns true if the argument is defined inside a specific
    # test (i.e. in this case, integration test since post_via_redirect is only available in integration test)
    def integration_test?
      defined?(post_via_redirect)
    end
end
