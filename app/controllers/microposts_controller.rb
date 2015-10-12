class MicropostsController < ApplicationController
  # rails verifies if a user is logged in before a user can create and/or destroy
  before_action :logged_in_user, only: [:create, :destroy]

  def create
  end

  def destroy
  end
end
