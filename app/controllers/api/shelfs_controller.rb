# frozen_string_literal: true

class Api::ShelfsController < Api::BaseController
  def summary
    limits = 7

    shared = current_user.owning_print_books.all_shared
                         .order(updated_at: :desc).limit(limits)
    lent = current_user.owning_print_books.all_borrowable
                       .order(updated_at: :desc).limit(limits)

    received = current_user.holding_print_books
                           .where.not(owner_id: current_user.id)
                           .all_shared.order(updated_at: :desc)
                           .limit(limits)
    borrowed = current_user.holding_print_books
                           .where.not(owner_id: current_user.id)
                           .all_borrowable.order(updated_at: :desc)
                           .limit(limits)

    personal = current_user.owning_print_books
                           .all_personal.order(updated_at: :desc).limit(limits)

    render json: { shared: print_books_to_json(shared),
                   lent: print_books_to_json(lent),
                   received: print_books_to_json(received),
                   borrowed: print_books_to_json(borrowed),
                   personal: print_books_to_json(personal) },
           status: :ok
  end

  def shared
    shared = current_user.owning_print_books
                         .all_shared.order(updated_at: :desc)
                         .page(page).per(per_page)

    render json: shared, status: :ok, each_serializer: PrintBookSerializer,
           meta: pagination_dict(shared)
  end

  def lent
    lent = current_user.owning_print_books
                       .all_borrowable.order(updated_at: :desc)
                       .page(page).per(per_page)

    render json: lent, status: :ok, each_serializer: PrintBookSerializer,
           meta: pagination_dict(lent)
  end

  def received
    received = current_user.holding_print_books
                           .where.not(owner_id: current_user.id)
                           .all_shared.order(updated_at: :desc)
                           .page(page).per(per_page)

    render json: received, status: :ok, each_serializer: PrintBookSerializer,
           meta: pagination_dict(received)
  end

  def borrowed
    borrowed = current_user.holding_print_books
                           .where.not(owner_id: current_user.id)
                           .all_borrowable.order(updated_at: :desc)
                           .page(page).per(per_page)

    render json: borrowed, status: :ok, each_serializer: PrintBookSerializer,
           meta: pagination_dict(borrowed)
  end

  def personal
    personal = current_user.owning_print_books
                           .all_personal.order(updated_at: :desc)
                           .page(page).per(per_page)

    render json: personal, status: :ok, each_serializer: PrintBookSerializer,
           meta: pagination_dict(personal)
  end

  private

  def print_books_to_json(print_books)
    print_books.map { |x| PrintBookSerializer.new(x).as_json }
  end
end
