class Ability
  include CanCan::Ability

  def initialize(user)
    if user.admin?
      can :manage, :all
    end

    unless user.guest?
      can :help, :page
      can :read, Note
      can [:create, :update, :destroy], Note, user_id: user.id
    end

    can :home, :page
  end
end
