class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)

    if user && user.authenticate(params[:session][:password])
      # go to profile (show) page
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
  end
end
