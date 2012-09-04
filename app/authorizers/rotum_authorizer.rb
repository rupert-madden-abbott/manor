class RotumAuthorizer < ApplicationAuthorizer
  def self.readable_by?(user)
    user.has_role? :sr
  end
end
