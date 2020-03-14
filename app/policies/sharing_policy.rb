# frozen_string_literal: true

class SharingPolicy
  attr_reader :user, :sharing

  def initialize(user, sharing)
    @user = user
    @sharing = sharing
  end

  def create?
    print_book = sharing

    unless print_book.shared?
      raise Pundit::NotAuthorizedError, reason: 'print_book.not_for_share'
    end
    if print_book.holder == user
      raise Pundit::NotAuthorizedError, reason: 'print_book.hold_the_book'
    end

    unless Sharing.current_applied_by(user.id)
                  .where(print_book_id: print_book.id).empty?
      raise Pundit::NotAuthorizedError, reason: 'print_book.request_duplicates'
    end

    true
  end

  def accept?
    unless sharing.holder == user
      raise Pundit::NotAuthorizedError, reason: 'print_book.not_the_holder'
    end
    unless sharing.print_book.holder == user
      raise Pundit::NotAuthorizedError, reason: 'print_book.not_the_holder'
    end

    true
  end

  def reject?
    accept?
  end

  def lend?
    accept?
  end

  def borrow?
    unless sharing.receiver == user
      raise Pundit::NotAuthorizedError, reason: 'print_book.not_the_receiver'
    end

    true
  end
end
