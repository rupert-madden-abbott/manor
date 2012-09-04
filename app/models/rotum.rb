class Rotum < ActiveRecord::Base
  has_many :duties, dependent: :destroy

  attr_accessible :ends, :starts

  resourcify
  include Authority::Abilities
  self.authorizer_name = 'RotumAuthorizer'

  def self.current
    where(assigned: true).order(:starts).last || last
  end

  def previous
    self.class.first(conditions: ["starts < ?", starts], order: "starts desc")
  end

  def next
    self.class.first(conditions: ["starts > ?", starts], order: "starts asc")
  end

  def name
    "#{starts_str} - #{ends_str}"
  end

  def starts_str
    starts.strftime('%d %B %Y')
  end

  def ends_str
    ends.strftime('%d %B %Y')
  end
end
