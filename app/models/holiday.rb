class Holiday < ActiveRecord::Base
  attr_accessible :day, :duty_ends, :duty_starts, :name
end
