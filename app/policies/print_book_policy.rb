class PrintBookPolicy < ApplicationPolicy
  attr_reader :user, :print_book

  def initialize(user, print_book)
    @user = user
    @print_book = print_book
  end

  def update?
    !(print_book.shared? && !print_book.sharings.current_actives.empty?)
  end
end
