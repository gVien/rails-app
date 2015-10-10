class PasswordResetsController < ApplicationController
  def new
  end

  def create
    @user = User.find_by(email: params[:password_reset][:email].downcase)
    if @user
      # create token & digest
      @user.create_reset_digest
      # send email to recover the password
      @user.send_password_reset_email
      # redirect to root url
      flash[:info] = "Password instructions sent to your email"
      redirect_to root_url
    else
      flash.now[:danger] = "The email is not recognized"
      render "new"
    end
  end

  def edit
  end
end
