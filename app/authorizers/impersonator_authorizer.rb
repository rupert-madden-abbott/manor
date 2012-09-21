class ImpersonatorAuthorizer < ApplicationAuthorizer
  def self.default(adjective, user)
    user.has_role?(:admin) || user.imposter?
  end
end
