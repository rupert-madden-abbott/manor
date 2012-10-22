class Preference < ActiveRecord::Base
  belongs_to :user
  belongs_to :duty, counter_cache: true
  delegate :name, to: :user, prefix: true
  delegate :day, to: :duty

  attr_accessible :user_id, :duty_id, :user, :duty

  validates_uniqueness_of :user_id, scope: :duty_id
end
