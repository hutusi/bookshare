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
    forbidden! I18n.t('api.errors.forbidden.print_book_not_for_share') unless print_book.shared?
    forbidden! I18n.t('api.errors.forbidden.request_self_book') if print_book.holder_id == current_user.id
    forbidden! I18n.t('api.errors.forbidden.request_duplicates') unless Sharing.current_applied_by(current_user.id)
                                                                               .where(print_book_id: params[:print_book_id])
                                                                               .empty?

    valid_params.merge!(receiver_id: current_user.id, holder_id: print_book.holder_id, book_id: print_book.book_id)
    sharing = Sharing.create! valid_params
    render json: sharing, status: :created
  end

  def accept
    valid_params = params.permit(:print_book_id, :application_reply)
    forbidden! I18n.t('api.errors.forbidden.not_the_holder') unless @sharing.holder_id == current_user.id
    @sharing.accept
    @sharing.update!(application_reply: valid_params[:application_reply])
    render json: @sharing, status: :created
  end

  def reject
    valid_params = params.permit(:print_book_id, :application_reply)
    forbidden! I18n.t('api.errors.forbidden.not_the_holder') unless @sharing.holder_id == current_user.id
    @sharing.reject
    @sharing.update!(application_reply: valid_params[:application_reply])
    render json: @sharing, status: :created
  end

  def lend
    forbidden! I18n.t('api.errors.forbidden.not_the_holder') unless @sharing.holder_id == current_user.id
    @sharing.lend
    @sharing.save
    render json: @sharing, status: :created
  end

  def borrow
    forbidden! I18n.t('api.errors.forbidden.not_the_applicant') unless @sharing.receiver_id == current_user.id
    @sharing.borrow_to current_user
    render json: @sharing, status: :created
  end

  private

  def find_sharing
    @sharing = Sharing.find_by id: params[:id]
  end
end
