class MicropostsController < ApplicationController
  # rails verifies if a user is logged in before a user can create and/or destroy
  before_action :logged_in_user, only: [:create, :destroy]

  def create
    @micropost = current_user.microposts.build(micropost_params)
    if @micropost.save
      flash[:success] = "Micropost successfully created!"
      redirect_to root_url
    else
      @feed_items = []
      render "static_pages/home"  # root_url
    end
  end

  def destroy
  end

  private
    def micropost_params
      params.require(:micropost).permit(:content)
    end
end
