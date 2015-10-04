class UsersController < ApplicationController
  # if a user attemps to access /users/1/edit, it checks for logged_in_user method
  # we limit to only the edit and update action only, since a user cannot edit or update if the user isn't logged in
  before_action :logged_in_user, only: [:index, :edit, :update]

  # like logged_in_user, correct_user checks if it is the correct user when a user attempts to edit/update another user's profile
  before_action :correct_user, only: [:edit, :update]

  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      log_in(@user)
      # flash is used to temporary message when a user visits the page the first time. It disppears on reload or visiting a second page
      flash[:success] = "Hi #{@user.name}, Welcome to the Rails App!"
      # @user means /users/:id
      # same as redirect_to user_url(@user)
      redirect_to @user
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
end
