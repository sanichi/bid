class Ability
  include CanCan::Ability

  def initialize(user)
    if user.admin?
      can :manage, :all
    end

    unless user.guest?
      can :help, :page
      can :read, Note
      can [:select, :review, :quit], Problem
    end

    can :home, :page
  end
end
