class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :populate_impersonatables

  Warden::Manager.after_set_user do |user,auth,opts|
    user.impersonated_by = auth.raw_session[:admin_id]
  end

  def time(hour = 0, min = 0)
    Time.now.utc.change({ hour: hour, min: min })
  end
  helper_method :time

  def populate_impersonatables
    if user_signed_in? && current_user.can_manage?(User)
      @impersonatables = Role.includes(:users).order("roles.name, users.name").all
    end
  end
end
