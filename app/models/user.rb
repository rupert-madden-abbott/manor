class User < ActiveRecord::Base
  devise :cas_authenticatable, :rememberable, :trackable
  rolify
  include Authority::UserAbilities
  include Authority::Abilities

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


  self.authorizer_name = 'UserAuthorizer'

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

  def can?(model, *actions)
    actions.any? { |action| send("can_#{action}?", model) }
  end

  def can_write?(model)
    can?(model, *[:create, :update, :delete])
  end

  def duty_weight
    duties.sum { |duty| duty.weight }
  end

  def days_to_duty(date)
    close_duties = duties.where("day <= ? AND day >= ?", date + 6, date - 6)
    if close_duties.present?
      duty = close_duties.min_by { |duty| (duty.day - date).abs }
      (duty.day - date).abs
    else
      7
    end
  end

  def imposter?
    impersonated_by.present?
  end

#  def inactive_message
#    self.deleted_at.nil? ? super : :account_has_been_deactivated
#  end
end
