# frozen_string_literal: true

class Api::ShelfsController < Api::BaseController
  def summary
    limits = 7

    shared = current_user.owning_books.for_share.order(updated_at: :desc).limit(limits)
    lent = current_user.owning_books.for_borrow.order(updated_at: :desc).limit(limits)

    received = current_user.holding_books.for_share.order(updated_at: :desc).limit(limits)
    borrowed = current_user.holding_books.for_borrow.order(updated_at: :desc).limit(limits)

    personal = current_user.owning_books.personal.order(updated_at: :desc).limit(limits)

    render json: { shared: shared, lent: lent, received: received,
                   borrowed: borrowed, personal: personal }, status: :ok
  end

  def shared
    shared = current_user.owning_books.for_share.order(updated_at: :desc)

    render json: { print_books: shared }, status: :ok
  end

  def lent
    lent = current_user.owning_books.for_borrow.order(updated_at: :desc)

    render json: { print_books: lent }, status: :ok
  end

  def received
    received = current_user.holding_books.for_share.order(updated_at: :desc)

    render json: { print_books: received }, status: :ok
  end

  def borrowed
    borrowed = current_user.holding_books.for_borrow.order(updated_at: :desc)

    render json: { print_books: borrowed }, status: :ok
  end

  def personal
    personal = current_user.owning_books.personal.order(updated_at: :desc)

    render json: { print_books: personal }, status: :ok
  end

  private
end
