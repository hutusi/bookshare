# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    # Use cancancan to define abilities, See the wiki for details:
    # https://github.com/CanCanCommunity/cancancan/wiki/Defining-Abilities

    user ||= User.new # guest user (not logged in)
    # if user.admin?
    #   can :manage, :all
    # end

    can :read, Book
    can :update, Book, creator: user

    can :read, PrintBook, property: :borrowable
    can :read, PrintBook, property: :shared
    can :manage, PrintBook, owner: user
    can :update, PrintBook, holder: user

    can :read, Deal
    can :update, Deal, sponsor: user
    can :update, Deal, receiver: user
    can :update, Deal, applicant: user
  end
end
