class DutyAuthorizer < ApplicationAuthorizer
  def self.updatable_by?(user)
    user.has_role? :rota
  end

  def self.default(adjective, user)
    return true
    user.has_role?(:manor) && user.has_any_role?(:dw, :admin)
  end
end
