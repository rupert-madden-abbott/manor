class ApplicationController < ActionController::Base
  protect_from_forgery
  Warden::Manager.after_set_user do |user,auth,opts|
    user.impersonated_by = auth.raw_session[:admin_id]
  end

  def time(hour = 0, min = 0)
    Time.now.utc.change({ hour: hour, min: min })
  end
  helper_method :time
end
