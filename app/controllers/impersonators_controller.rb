class ImpersonatorsController < ApplicationController
  authorize_resource class: false
  prepend_before_filter { env["devise.skip_trackable"] = true }
  before_filter :authenticate_user!

  def new
    session[:admin_id] = current_user.id
    user = User.find(params[:user_id])
    sign_in(user)

    redirect_to :back, notice: "Now impersonating #{user.name}"
  end

  def destroy
    user = User.find(session[:admin_id])
    sign_in :user, user
    session[:admin_id] = nil
    redirect_to :back, notice: "Stopped impersonating"
  end
end
