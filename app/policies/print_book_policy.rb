# frozen_string_literal: true

class PrintBookPolicy
  attr_reader :user, :print_book

  def initialize(user, print_book)
    @user = user
    @print_book = print_book
  end

  def update?
    raise Pundit::NotAuthorizedError, reason: 'print_book.not_the_owner' if print_book.owner != user

    if print_book.shared? && !print_book.sharings.current_actives.empty?
      raise Pundit::NotAuthorizedError, reason: 'print_book.not_allow_update_circulated_shared'
    end

    true
  end

  def update_property?
    update?
  end

  def update_status?
    raise Pundit::NotAuthorizedError, reason: 'print_book.not_the_holder' if print_book.holder != user

    true
  end

  def destroy?
    raise Pundit::NotAuthorizedError, reason: 'print_book.not_the_owner' if print_book.owner != user

    raise Pundit::NotAuthorizedError, reason: 'print_book.not_personal' if print_book.personal?

    true
  end
end
