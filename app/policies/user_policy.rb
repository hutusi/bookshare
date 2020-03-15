# frozen_string_literal: true

class UserPolicy
  attr_reader :current_user, :user

  def initialize(current_user, user)
    @current_user = current_user
    @user = user
  end

  def update?
    if current_user != user
      raise Pundit::NotAuthorizedError, reason: 'user.not_self'
    end

    true
  end
end
