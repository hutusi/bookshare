# frozen_string_literal: true

class BorrowingPolicy
  attr_reader :user, :borrowing

  def initialize(user, borrowing)
    @user = user
    @borrowing = borrowing
  end

  def create?
    print_book = borrowing

    raise Pundit::NotAuthorizedError, reason: 'print_book.not_for_borrow' unless print_book.borrowable?
    raise Pundit::NotAuthorizedError, reason: 'print_book.hold_the_book' if print_book.holder == user

    unless Borrowing.current_applied_by(user.id)
                    .where(print_book_id: print_book.id).empty?
      raise Pundit::NotAuthorizedError, reason: 'print_book.request_duplicates'
    end

    true
  end

  def accept?
    raise Pundit::NotAuthorizedError, reason: 'print_book.not_the_holder' unless borrowing.holder == user
    raise Pundit::NotAuthorizedError, reason: 'print_book.not_the_holder' unless borrowing.print_book.holder == user

    true
  end

  def reject?
    accept?
  end

  def lend?
    accept?
  end

  def borrow?
    raise Pundit::NotAuthorizedError, reason: 'print_book.not_the_receiver' unless borrowing.receiver == user

    true
  end

  def return?
    borrow?
  end

  def finish?
    accept?
  end
end
