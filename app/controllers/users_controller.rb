class UsersController < ApplicationController
  # if a user attemps to access /users/1/edit, it checks for logged_in_user method
  # we limit to only the edit and update action only, since a user cannot edit or update if the user isn't logged in
  # update: added index for pagination (if user is logged in) and destroy for admin to destroy (if admin user is logged in)
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy]

  # like logged_in_user, correct_user checks if it is the correct user when a user attempts to edit/update another user's profile
  before_action :correct_user, only: [:edit, :update]

  # enforcing security hole by checking if the user is the admin before performing the destroy action
  # this allows the admin user to delete, otherwise (without checking if the user is admin) anyone can delete user using the command line
  before_action :admin_user, only: :destroy

  def index
    @users = User.where(activated: true).paginate(page: params[:page])
  end

  def show
    @user = User.find(params[:id])
    # redirect to root url if user's account is not activated
    # note `and` and `&&` are nearly identical but `&&` takes precedence over `and` and binds too tightly to root_url
    redirect_to root_url and return unless @user.activated?
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      @user.send_activation_email
      flash[:info] = "You have successfully signed up for an account. Please check your email to activate your account. If you cannot find it, please check your spam folder."
      redirect_to root_url
    else
      render "new"
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      flash[:success] = "Your profile have been updated successfully"
      redirect_to(@user)
    else
      render "edit" # if edit fails
    end
  end

  def destroy
    user = User.find(params[:id]).destroy
    flash[:success] = "#{user.name.capitalize} is successfully deleted."
    redirect_to users_url
  end

  private

    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end

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

    # this method checks that when current user attempts to edit another user's
    # profile (change "/users/1/edit" to "/users/2/edit), it redirect to root url
    # confirms the correct user
    def correct_user
      user = User.find(params[:id])
      redirect_to root_url unless current_user?(user)
    end

    # confirms an admin user
    # ensure that only the admin user is allowed to delete the user
    def admin_user
      redirect_to root_url unless current_user.admin?
    end
end
