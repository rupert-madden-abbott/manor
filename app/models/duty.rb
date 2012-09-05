class Duty < ActiveRecord::Base
  has_many :preferences
  has_and_belongs_to_many :users
  belongs_to :rotum

  attr_accessible :day, :ends, :starts, :user_id

  resourcify
  include Authority::Abilities

  def name
    "#{day_str} #{times_str}"
  end

  def day_str
    day.strftime('%A %d %B %Y')
  end

  def starts_str
    starts.strftime('%H:%M')
  end

  def ends_str
    ends.strftime('%H:%M')
  end

  def times_str
    "#{starts_str} - #{ends_str}"
  end
end
