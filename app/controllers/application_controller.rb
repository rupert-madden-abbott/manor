class ApplicationController < ActionController::Base
  protect_from_forgery

  def time(hour = 0, min = 0)
    Time.now.utc.change({ hour: hour, min: min })
  end
  helper_method :time
end
