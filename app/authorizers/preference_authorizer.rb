class PreferenceAuthorizer < ApplicationAuthorizer
  def self.default(adjective, user)
    user.has_role :sr
  end
end
