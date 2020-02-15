# frozen_string_literal: true

class Api::BorrowingsController < Api::BaseController
  before_action :find_borrowing, only: [:show, :accept, :reject,
                                        :lend, :borrow, :return, :finish]

  def index
    @borrowings = Borrowing.all.order(updated_at: :desc)
    render json: @borrowings, status: :ok, each_serializer: BorrowingSerializer if stale?(last_modified: @borrowings.maximum(:updated_at))
  end

  def show
    render json: @borrowing, serializer: BorrowingPreviewSerializer if stale?(last_modified: @borrowing.updated_at)
  end

  def create
    valid_params = params.permit(:print_book_id, :application_reason)
    print_book = PrintBook.find_by id: params[:print_book_id]
    not_found! if print_book.nil?
    forbidden! I18n.t('api.errors.forbidden.print_book_not_for_borrow') unless print_book.borrowable?
    forbidden! I18n.t('api.errors.forbidden.request_self_book') if print_book.holder_id == current_user.id
    forbidden! I18n.t('api.errors.forbidden.request_duplicates') unless Borrowing.current_applied_by(current_user.id)
                                                                                 .where(print_book_id: params[:print_book_id])
                                                                                 .empty?

    valid_params.merge!(receiver_id: current_user.id, holder_id: print_book.holder_id, book_id: print_book.book_id)
    borrowing = Borrowing.create! valid_params
    render json: borrowing, status: :created
  end

  def accept
    valid_params = params.permit(:print_book_id, :application_reply)
    forbidden! I18n.t('api.errors.forbidden.not_the_holder') unless @borrowing.holder_id == current_user.id
    @borrowing.accept
    @borrowing.update!(application_reply: valid_params[:application_reply])
    render json: @borrowing, status: :created
  end

  def reject
    valid_params = params.permit(:print_book_id, :application_reply)
    forbidden! I18n.t('api.errors.forbidden.not_the_holder') unless @borrowing.holder_id == current_user.id
    @borrowing.reject
    @borrowing.update!(application_reply: valid_params[:application_reply])
    render json: @borrowing, status: :created
  end

  def lend
    forbidden! I18n.t('api.errors.forbidden.not_the_holder') unless @borrowing.holder_id == current_user.id
    @borrowing.lend
    @borrowing.save
    render json: @borrowing, status: :created
  end

  def borrow
    forbidden! I18n.t('api.errors.forbidden.not_the_applicant') unless @borrowing.receiver_id == current_user.id
    @borrowing.borrow_to current_user
    render json: @borrowing, status: :created
  end

  def return
    forbidden! I18n.t('api.errors.forbidden.not_the_applicant') unless @borrowing.receiver_id == current_user.id
    @borrowing.return
    @borrowing.save
    render json: @borrowing, status: :created
  end

  def finish
    forbidden! I18n.t('api.errors.forbidden.not_the_holder') unless @borrowing.holder_id == current_user.id
    @borrowing.return_to current_user
    render json: @borrowing, status: :created
  end

  private

  def find_borrowing
    @borrowing = Borrowing.find_by id: params[:id]
  end
end
