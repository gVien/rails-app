module SessionsHelper

  # note that session is a temporary cookie that expires automatically upon browser close
  # a cookie (which will be implemented later) stores the session longer even after a browser is closed
  # method to login the user
  def log_in(user)
    session[:user_id] = user.id
  end

  # return current user that is in session (if any)
  def current_user
    # find method raises an error if session[:user_id] is nil
    @current_user ||= User.find_by(id: session[:user_id])
  end

  # returns true if the user is logged in, false otherwise
  def logged_in?
    !current_user.nil?
  end
end
