class AccountActivationsController < ApplicationController

  # activate the account
  def edit
    # the params[:email] is located in
    # http://localhost:3000/account_activations/v3Q4hK3TwtJCxlE5bdLaRw/edit?email=example%40railstutorial.org
    user = User.find_by(email: params[:email])
    if user && !user.activated? && user.authenticated?(:activation, params[:id])  #the params[:id] is actually the token in the url above
      user.update_attribute(:activated, true)
      user.update_attribute(:activated_at, Time.zone.now)
      log_in(user)
      flash[:success] = "Your account has been activated!"
      redirect_to(user)
    else
      flash[:danger] = "Invalid activation link"
      redirect_to(root_url)
    end
  end
end
