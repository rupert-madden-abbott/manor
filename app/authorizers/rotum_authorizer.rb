class RotumAuthorizer < ApplicationAuthorizer
  def self.readable_by?(user)
    user.has_any_role? :staff, :sr, :dw, :admin
  end

  def self.default(adjective, user)
    user.has_role(:manor) && user.has_any_role?(:dw, :admin)
  end
end
