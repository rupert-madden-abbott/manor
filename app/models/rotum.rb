class Rotum < ActiveRecord::Base
  has_many :duties, dependent: :destroy, order: "day asc, starts asc"

  attr_accessible :ends, :starts

  scope :current, where("ends > ?", Date.today).order(:ends).limit(1)
  scope :complete, includes(duties: { users: :preferences })
  scope :admin, includes(duties: { preferences: [:user, { duty: :rotum }] })
  scope :next, where("starts >= ?", Date.today).order(:starts).limit(1)
  scope :previous, where("ends <= ?", Date.today).order(:starts).limit(1)

  def next(offset = 0)
    self.class.where("starts >= ?", ends).order(:starts).offset(offset).first
  end

  def previous(offset = 0)
    self.class.where("ends <= ?", starts).order(:starts).offset(offset).last
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

  def build_duty(date, starts = 19, ends = 7)
    duties.build day: date, starts: time(starts), ends: time(ends)
  end

  def build_saturday(date)
    build_duty(date, 12)
  end

  def build_sunday_am(date)
    build_duty(date, 8, 17)
  end

  def build_sunday_pm(date)
    build_duty(date, 17)
  end

  def build_duty_for(date)
    if date.saturday?
      build_saturday date
    elsif date.sunday?
      build_sunday_am date
      build_sunday_pm date
    else
      build_duty date
    end
  end

  def create_with_duties
    if valid?
      Event.in(dates).each do |event|
        dates.delete(event.day)
        build_duty(event.day, event.duty_starts, event.duty_ends)
      end

      dates.each do |date|
        build_duty_for date
      end

      save
    else
      false
    end
  end

  def assign_duties
    users = User.for_assignment

    last_selected = nil
    duties.each do |duty|
      selected = users.min_by do |user|
        user.conditions_for_assignment(duty, last_selected)
      end

      selected.duties << duty
      last_selected = selected
    end

    self.assigned = true
  end

  def duty_weight
    duties.sum { |duty| duty.weight }
  end

  private
  def time(hour = 0, min = 0)
    Time.now.utc.change({ hour: hour, min: min })
  end
end
