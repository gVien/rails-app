module SessionsHelper

  # note that session is a temporary cookie that expires automatically upon browser close
  # a cookie (which will be implemented later) stores the session longer even after a browser is closed
  # method to login the user
  def log_in(user)
    session[:user_id] = user.id
  end

end
