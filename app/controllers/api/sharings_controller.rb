# frozen_string_literal: true

class Api::SharingsController < Api::BaseController
  before_action :find_sharing, only: [:show, :accept, :reject,
                                      :lend, :borrow]

  def index
    @sharings = Sharing.all.order(updated_at: :desc)
    if stale?(last_modified: @sharings.maximum(:updated_at))
      render json: @sharings, status: :ok, each_serializer: SharingSerializer
    end
  end

  def show
    if stale?(last_modified: @sharing.updated_at)
      render json: @sharing, serializer: SharingPreviewSerializer
    end
  end

  def create
    valid_params = params.permit(:print_book_id, :application_reason)
    print_book = PrintBook.find_by id: params[:print_book_id]
    not_found! if print_book.nil?

    authorize print_book, :create?, policy_class: SharingPolicy

    valid_params[:receiver_id] = current_user.id
    valid_params[:holder_id] = print_book.holder_id
    sharing = Sharing.create! valid_params
    render json: sharing, status: :created
  end

  def accept
    valid_params = params.permit(:print_book_id, :application_reply)
    authorize @sharing, :accept?

    @sharing.accept
    @sharing.update!(application_reply: valid_params[:application_reply])
    render json: @sharing, status: :created
  end

  def reject
    valid_params = params.permit(:print_book_id, :application_reply)
    authorize @sharing, :reject?

    @sharing.reject
    @sharing.update!(application_reply: valid_params[:application_reply])
    render json: @sharing, status: :created
  end

  def lend
    authorize @sharing, :lend?
    @sharing.lend
    @sharing.save
    render json: @sharing, status: :created
  end

  def borrow
    authorize @sharing, :borrow?
    @sharing.borrow_to current_user
    render json: @sharing, status: :created
  end

  private

  def find_sharing
    @sharing = Sharing.find_by id: params[:id]
  end
end
