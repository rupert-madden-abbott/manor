class Holiday < ActiveRecord::Base
  attr_accessible :day, :duty_ends, :duty_starts, :name

  scope :in, ->(dates) { find(:all, conditions: ["day IN (?)", dates]) }

end
