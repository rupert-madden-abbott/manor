class Ability
  include CanCan::Ability

  def initialize(user)
    can :home, :static
    can :destroy, :impersonator
    if user && !user.deleted?
      can :destroy, Preference, user_id: user.id

      if user.has_any_role? :staff, :dw, :sr
        can :read, User
      end

      if user.has_any_role? :staff, :sr, :rota
        can :read, Duty
        can :read, Rotum
      end

      if user.has_role? :dw
        can :manage, Duty
        can :manage, Rotum
      end

      if user.has_role? :rota
        can :take, Duty
        can :create, Preference
      end

      if user.has_role? :admin
        can :manage, :all
      end
    end
  end
end
