class PreferenceAuthorizer < ApplicationAuthorizer
  def self.creatable_by?(user)
    user.has_any_role? :sr, :dw, :admin
  end

  def self.deletable_by?(user)
    user.has_any_role? :sr, :dw, :admin
  end

  def self.default(adjective, user)
    user.has_role? :admin
  end
end
