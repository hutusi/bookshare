# frozen_string_literal: true

class SharingPolicy
  attr_reader :user, :sharing

  def initialize(user, sharing)
    @user = user
    @sharing = sharing
  end

  def create?
    print_book = sharing

    raise Pundit::NotAuthorizedError, reason: 'print_book.not_for_share' unless print_book.shared?
    raise Pundit::NotAuthorizedError, reason: 'print_book.hold_the_book' if print_book.holder == user

    unless Sharing.current_applied_by(user.id)
                  .where(print_book_id: print_book.id).empty?
      raise Pundit::NotAuthorizedError, reason: 'print_book.request_duplicates'
    end

    true
  end

  def accept?
    raise Pundit::NotAuthorizedError, reason: 'print_book.not_the_holder' unless sharing.holder == user
    raise Pundit::NotAuthorizedError, reason: 'print_book.not_the_holder' unless sharing.print_book.holder == user

    true
  end

  def reject?
    accept?
  end

  def lend?
    accept?
  end

  def borrow?
    raise Pundit::NotAuthorizedError, reason: 'print_book.not_the_receiver' unless sharing.receiver == user

    true
  end
end
