class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  include SessionsHelper

  private

    # before filter

    # check if the user is logged in
    # this method is being used with before filter, which uses the before_action method,
    # which checks for a particular to be called method before it performs the given action
    def logged_in_user
      unless logged_in?   #if user is not logged in (if false)
        store_location  # friendly forwarding
        flash[:danger] = "Please log in to continue."
        redirect_to login_url
      end
    end
end
