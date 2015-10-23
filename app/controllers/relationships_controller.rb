class RelationshipsController < ApplicationController
  before_action :logged_in_user #execute logged_in_user method before follow/unfollow action can be done

  def create
    # get the id of the user that the current user wants to follow in the hidden field (see follow form)
    # instance variable is needed for ajax call for the follow/unfollow button
    @user = User.find(params[:followed_id])
    #current user follows the user
    current_user.follow(@user)
    respond_to do |format|
      #redirect back to the user page (to refresh the page)
      format.html { redirect_to user_path(@user) } # or simply @user
      # for ajax
      format.js
    end
  end

  def destroy
    # find the user that the current user is following
    #followed is the user that athe current user is following (note there is also `follower` which is the current user)
    # instance variable is needed for ajax call for the follow/unfollow button
    @user = Relationship.find(params[:id]).followed
    current_user.unfollow(@user)
    respond_to do |format|
      format.html { redirect_to @user }
      format.js
    end
  end
end
