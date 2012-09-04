class Preference < ActiveRecord::Base
  belongs_to :user
  belongs_to :duty

  attr_accessible :user_id, :duty_id, :user, :duty

  resourcify
  include Authority::Abilities
  self.authorizer_name = 'PreferenceAuthorizer'
end
