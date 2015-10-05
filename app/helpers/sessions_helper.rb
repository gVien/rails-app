module SessionsHelper

  # note that session is a temporary cookie that expires automatically upon browser close
  # a cookie (which will be implemented later) stores the session longer even after a browser is closed
  # method to login the user
  def log_in(user)
    session[:user_id] = user.id
  end

  # remembers a user in a persistent session
  def remember(user)
    user.remember
    # cookie (which like session, can be treated as a hash) consists of two pieces of info: a value and an optional expires date. e.g
    # cookies[:remember_token] = { value: some_token, expires: 20.years.from_now.utc }
    # which is the same as cookies.permanent[:remember_token] = remember_token
    # To store the user's id in the cookies we can do (like session)
    # cookies[:user_id] = user.id
    # this exposes the user.id in a cookie, so we use a signed cookie
    #(which securely encrypted the cookie before placing it on the browser)
    # cookies.signed[:user_id] = user.id
    # putting them together becomes
    cookies.permanent.signed[:user_id] = user.id
    cookies.permanent[:remember_token] = user.remember_token  # setting the :remember_token value to link with the user's token (hashed) value (e.g "KQTL7G3N7ziLneWdQaSfvw")
  end


  # check if the user is current user, returns true if it is, false otherwise
  def current_user?(user)
    user == current_user
  end

  # returns the user corresponding to the remember token cookie (since we incorporated cookies, this note was modified from the previous one, which is "return current user that is in session (if any)") - this is for reference
  def current_user
    # to incorporate the remember me feature, we needed to modify the original code:
    # @current_user ||= User.find_by(id: session[:user_id])
    # to incorporate cookies

    # to get persistent sessions, we want to retrieve the user from the temporary session
    # if sessin[:user_id] exists
    # otherwise, we should look for cookies[:user_id] to retrieve (and login) the user
    # corresponding to the persistent session

    # note that user_id = session[:user_id] is not a comparison
    # it is an assignment, which reads "if session of user id exists (while setting user id to session of user id)"
    # do NOT READ it as "if user id equals session of user id...)", a parenthesis is there to mean it's an assignment
    if (user_id = session[:user_id])  # if session of user id exists while setting it equal to user id
    # find method raises an error if session[:user_id] is nil
      @current_user ||= User.find_by(id:user_id)
    elsif (user_id = cookies.signed[:user_id])
      # raise   # test still passes, so this elsif branch is not tested (test would raise an error if it gets here)
      user = User.find_by(id: user_id)  # cookies
      if user && user.authenticated?(cookies[:remember_token])
        log_in(user)
        @current_user = user
      end
    end
  end

  # returns true if the user is logged in, false otherwise
  def logged_in?
    !current_user.nil?
  end

  # this method forgets a persistent session (cookies)
  def forget(user)
    user.forget
    cookies.delete(:user_id)  # or cookies[:user_id] = nil
    cookies.delete(:remember_token)   # or cookies[:remember_token] = nil
  end

  # helper method to log out the current user
  def log_out
    forget(current_user)
    session.delete(:user_id)  #or session[:user_id] = nil
    @current_user = nil #this is needed if @current_user is created before the destroy action (which is not in the case now. this is for completeness and security reason)
  end

  # redirect to store location (or the default) after the non-login user is logged in
  def redirect_back_to_or(default)
    redirect_to(session[:forwarding_url] || default)
    session.delete(:forwarding_url)
  end

  # stores the URL the non-login user is trying to access, before logging in
  def store_location
    # request.url is used to get the requested url
    session[:forwarding_url] = request.url if request.get?
  end
end
