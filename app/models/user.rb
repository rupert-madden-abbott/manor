class User < ActiveRecord::Base
  has_many :preferences
  has_and_belongs_to_many :duties

  attr_accessible :name, :username, :role_ids, :roles

  validates_presence_of :name, :username, :roles
  validates_uniqueness_of :username

  scope :for_assignment, not_deleted.includes(:duties, :preferences)
    .joins(:roles).where(roles: { name: 'sr' })

  devise :cas_authenticatable, :rememberable, :trackable
  rolify
  include Authority::UserAbilities
  include Authority::Abilities

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
#  def inactive_message
#    self.deleted_at.nil? ? super : :account_has_been_deactivated
#  end
end
