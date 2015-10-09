class SessionsController < ApplicationController
  def new
  end

  def create
    @user = User.find_by(email: params[:session][:email].downcase)

    if @user && @user.authenticate(params[:session][:password])
      if @user.activated?
        log_in(@user)
        params[:session][:remember_me] == "1" ? remember(@user) : forget(@user) # value of checkbox is "1", and "0" if unchecked
      # redirect_to @user  # or user_url(user) -- not need if friendly forwarding is used
        redirect_back_to_or(@user)  #friendl forwarding
      else
        flash[:warning] = "Account not activated. Check your email for the activation link."
        redirect_to root_url
      end
    else
      # create an error message and render log in page
      # flash does not work like the one in the user controller since the render method does not count as a request
      # the flash message persists two request longer than we want
      # must use .now[:danger] to correct this minor bug
      flash.now[:danger] = "Invalid email/password combination"
      render "new"
    end
  end

  def destroy
    # the condition for log_out is needed to prevent multiple tabs of the site error (e.g. if a user logs off on one tab, it does not cause an error if the user tries to log out again in the second tab)
    log_out if logged_in?
    redirect_to root_url
  end
end
