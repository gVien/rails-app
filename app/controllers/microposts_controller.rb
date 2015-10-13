class MicropostsController < ApplicationController
  # rails verifies if a user is logged in before a user can create and/or destroy
  before_action :logged_in_user, only: [:create, :destroy]
  # check for correct user before a destroy action can be done
  before_action :correct_user, only: [:destroy]

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
    @micropost.destroy  # @micropost here is from correct_user
    flash[:success] = "Micropost successfully deleted"
    # request.referrer is HTTP_REFERER is the previous URL
    # This is similar to the friendly forwarding request.url
    redirect_to request.referrer || root_url
  end

  private
    def micropost_params
      params.require(:micropost).permit(:content, :picture)
    end

    # check if it's the correct user
    def correct_user
      @micropost = current_user.microposts.find_by(id: params[:id]) # find the micropost for current user with an id
      # p "*" * 50
      # p @micropost
      # p "*" * 50
      redirect_to root_url if @micropost.nil?
    end
end
