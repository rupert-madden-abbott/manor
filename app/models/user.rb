class User < ActiveRecord::Base
  devise :cas_authenticatable, :rememberable, :trackable
  rolify

  has_many :preferences, dependent: :destroy
  has_and_belongs_to_many :duties

  attr_accessor :impersonated_by
  attr_accessible :name, :username, :role_ids, :roles, :email, :mobile,
    :extension, :responsibilites, :residence

  validates_presence_of :name, :username, :roles
  validates_uniqueness_of :username

  scope :archived, deleted
  scope :active, not_deleted
  scope :on_rota, joins(:roles).where(roles: { name: :rota }).not_deleted
  scope :for_assignment, on_rota.includes(:duties, :preferences)

  def self.filter_by(user, filters = nil)
    users = order(:name)
    users = if user.can? :manage, User
      users.includes(:roles)
    else
      users.all
    end

    if filters.present?
      Array.wrap(filters).each do |filter|
        users = users.send(filter)
      end
    end
    users
  end

  def to_s
    name
  end

  def current_sign_in
    current_sign_in_at.strftime("%H:%M %d/%m/%Y") if current_sign_in_at.present?
  end

  def last_sign_in
    last_sign_in_at.strftime("%H:%M %d/%m/%Y") if last_sign_in_at.present?
  end

  def role_names
    roles.map { |role| role.name }.join(' ')
  end

  def find_preference_by_duty(duty)
    preferences.select do |preference|
      preference.duty_id == duty.id
    end.first
  end

  def next_duty
    @next_duty ||= duties.where("day >= ?", Date.today).order('day asc').first
  end

  def duty_weight
    duties.sum { |duty| duty.weight }
  end

  def duty_count_by(wday)
    duties.select { |duty| duty.wday == wday }.size
  end

  def imposter?
    impersonated_by.present?
  end

  def has_preference?(duty)
    preferences.where(duty_id: duty).present?
  end

  def conditions_for_assignment(duty, last_selected)
    [
      has_preference?(duty),
      self == last_selected,
      duty_weight,
      duty_count_by(duty.wday),
      -preferences.size
    ]
  end

  def ability
    @ability ||= Ability.new(self)
  end
  delegate :can?, :cannot?, to: :ability

#  def inactive_message
#    self.deleted_at.nil? ? super : :account_has_been_deactivated
#  end
end
