# frozen_string_literal: true

class Api::BorrowingsController < Api::BaseController
  before_action :find_borrowing, only: [:show, :accept, :reject,
                                        :lend, :borrow, :return, :finish]

  def index
    @borrowings = Borrowing.all.order(updated_at: :desc)
    return unless stale?(last_modified: @borrowings.maximum(:updated_at))

    render json: @borrowings, status: :ok, each_serializer: BorrowingSerializer
  end

  def show
    return unless stale?(last_modified: @borrowing.updated_at)

    render json: @borrowing, serializer: BorrowingPreviewSerializer
  end

  def create
    valid_params = params.permit(:print_book_id, :application_reason)
    print_book = PrintBook.find_by id: params[:print_book_id]
    not_found! if print_book.nil?

    authorize print_book, :create?, policy_class: BorrowingPolicy

    valid_params[:receiver_id] = current_user.id
    valid_params[:holder_id] = print_book.holder_id
    borrowing = Borrowing.create! valid_params
    render json: borrowing, status: :created
  end

  def accept
    valid_params = params.permit(:print_book_id, :application_reply)
    authorize @borrowing, :accept?
    @borrowing.accept
    @borrowing.update!(application_reply: valid_params[:application_reply])
    render json: @borrowing, status: :created
  end

  def reject
    valid_params = params.permit(:print_book_id, :application_reply)
    authorize @borrowing, :reject?
    @borrowing.reject
    @borrowing.update!(application_reply: valid_params[:application_reply])
    render json: @borrowing, status: :created
  end

  def lend
    authorize @borrowing, :lend?
    @borrowing.lend
    @borrowing.save
    render json: @borrowing, status: :created
  end

  def borrow
    authorize @borrowing, :borrow?
    @borrowing.borrow_to current_user
    render json: @borrowing, status: :created
  end

  def return
    authorize @borrowing, :return?
    @borrowing.return
    @borrowing.save
    render json: @borrowing, status: :created
  end

  def finish
    authorize @borrowing, :finish?
    @borrowing.return_to current_user
    render json: @borrowing, status: :created
  end

  private

  def find_borrowing
    @borrowing = Borrowing.find_by id: params[:id]
  end
end
