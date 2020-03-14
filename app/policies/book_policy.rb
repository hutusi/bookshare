# frozen_string_literal: true

class BookPolicy
  attr_reader :user, :book

  def initialize(user, book)
    @user = user
    @book = book
  end

  def create?
    false
  end

  def update?
    if book.creator != user
      raise Pundit::NotAuthorizedError, reason: 'book.not_the_creator'
    end

    false
  end

  def destroy?
    update?
  end
end
