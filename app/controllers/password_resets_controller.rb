class PasswordResetsController < ApplicationController
  before_action :get_user, only: [:edit, :update] #checks if the user exists before the edit & update action can be performed
  before_action :valid_user, only: [:edit, :update] #check if user is valid before  the edit & update action can be performed (it renders password reset page)

  def new
  end

  # generate password reset info (token + digest + send email) after request
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

  private
    # find the user (in the password reset edit view)
    def get_user
      @user = User.find_by(email: params[:email])
    end

    # verify if the user is valid, activated, and authenticated (if a user has submitted password reset form) otherwise redirect to root url
    def valid_user
      unless @user && @user.activated? && @user.authenticated?(:reset, params[:id])  #note params[:id] is the token (and not the numerical id, e.g. 1, 5, etc)
        flash[:info] = "Invalid Request."
        redirect_to root_url
      end
    end
end
