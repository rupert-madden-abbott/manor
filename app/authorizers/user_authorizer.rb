class UserAuthorizer < ApplicationAuthorizer
  def self.readable_by?(user)
    user.has_any_role? :staff, :sr, :dw, :admin
  end

  def self.default(adjective, user)
    user.has_role?(:admin)
  end
end
