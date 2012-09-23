class Rotum < ActiveRecord::Base
  has_many :duties, dependent: :destroy, order: "day asc, starts asc"

  attr_accessible :ends, :starts

  resourcify
  include Authority::Abilities
  self.authorizer_name = 'RotumAuthorizer'

  scope :current, where("ends > ?", Date.today).includes(duties: { users: :preferences }).limit(1).order(:ends)
  scope :complete, includes(duties: { users: :preferences })
  scope :admin, includes(duties: { preferences: :user })

  def self.next(rotum, offset = 0)
    if rotum.present?
      where("starts >= ?", rotum.ends).order(:starts).offset(offset).first
    end
  end

  def self.previous(rotum, offset = 0)
    if rotum.present?
      where("ends <= ?", rotum.starts).order(:starts).offset(offset).last
    end
  end

  def self.find_relative(id)
    if id == 'current'
      @rotum = Rotum.current.first || Rotum.last
    elsif id == 'next'
      @rotum = Rotum.next(Rotum.current.first)
    else
      @rotum = Rotum.find(id)
    end
  end

  def to_s
    "#{starts_str} - #{ends_str}"
  end

  def starts_str
    starts.strftime('%d %B %Y')
  end

  def ends_str
    ends.strftime('%d %B %Y')
  end

  def dates
    (starts..ends).to_a
  end

  def create_with_duties
    if valid?
      events = Event.in(dates)
      events.each do |event|
        dates.delete(event.day)
        duties.build day: event.day, starts: event.duty_starts, ends: event.duty_ends
      end

      dates.each do |date|
        if date.saturday?
          duties.build day: date, starts: time(12), ends: time(7)
        elsif date.sunday?
          duties.build day: date, starts: time(8), ends: time(17)
          duties.build day: date, starts: time(17), ends: time(7)
        else
          duties.build day: date, starts: time(19), ends: time(7)
        end
      end

      save
    else
      false
    end
  end

  def duty_weight
    duties.sum { |duty| duty.weight }
  end

  private
  def time(hour = 0, min = 0)
    Time.now.utc.change({ hour: hour, min: min })
  end
end
