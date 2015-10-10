class PasswordResetsController < ApplicationController
  #checks if the user exists before the edit & update action can be performed
  before_action :get_user, only: [:edit, :update]
  #check if user is valid before  the edit & update action can be performed (it renders password reset page)
  before_action :valid_user, only: [:edit, :update]
  # check for expiration before the edit & update action can be performed
  before_action :check_expiration, only: [:edit, :update] # case #1

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

  # edit & update check for 4 cases
  # 1. an expired reset (applies to edit & update)
  # 2. a successful reset (applies to update)
  # 3. a failed reset (invalid password) - applies to update
  # 4. a failed reset that seems successful initially (a blank password) - applies to update
  def edit
  end

  def update
    if params[:user][:password].empty?  # case #4
      # add error for password if it's empty
      @user.errors.add(:password, "Password cannot be empty")
      render "edit"
    elsif @user.update_attributes(user_params) # case #2
      log_in @user
      flash[:success] = "Password reset successfully"
      redirect_to @user
    else # case #3
      render "edit"
    end
  end

  private

    def user_params
      params.require(:user).permit(:password, :password_confirmation)
    end

    # before filters

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

    # check if password is expired
    def check_expiration
      if @user.password_reset_expired?  # need to define this method in User ctrler
        flash[:danger] = "The password reset link has expired. Please reset your password again"
        redirect_to new_password_reset_url
      end
    end
end
