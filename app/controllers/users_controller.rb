class UsersController < ApplicationController

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
end
