# frozen_string_literal: true

class PrintBookPolicy < ApplicationPolicy
  attr_reader :user, :print_book

  def initialize(user, print_book)
    @user = user
    @print_book = print_book
  end

  def update?
    if print_book.shared? && !print_book.sharings.current_actives.empty?
      raise Pundit::NotAuthorizedError, reason: 'print_book.not_allow_update_circulated_shared'
    end

    true
  end
end
