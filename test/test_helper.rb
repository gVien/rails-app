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
end
