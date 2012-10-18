class Preference < ActiveRecord::Base
  belongs_to :user
  belongs_to :duty, counter_cache: true

  attr_accessible :user_id, :duty_id, :user, :duty
end
