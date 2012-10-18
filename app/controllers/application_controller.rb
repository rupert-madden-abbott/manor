class ApplicationController < ActionController::Base
  protect_from_forgery

  Warden::Manager.after_set_user do |user,auth,opts|
    user.impersonated_by = auth.raw_session[:admin_id]
  end

  check_authorization unless: :devise_controller?
  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, :alert => exception.message
  end

  before_filter :populate_impersonated

  def time(hour = 0, min = 0)
    Time.now.utc.change({ hour: hour, min: min })
  end
  helper_method :time

  def populate_impersonated
    if user_signed_in? && can?(:manage, User)
      @impersonated = Role.includes(:users).order("roles.name, users.name").all
    end
  end
end
