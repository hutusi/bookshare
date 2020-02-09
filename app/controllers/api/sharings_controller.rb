# frozen_string_literal: true

class Api::SharingsController < Api::BaseController
  before_action :find_sharing, only: [:show, :accept, :reject, 
                                      :lend, :borrow]

  def index
    @sharings = Sharing.all.order(updated_at: :desc)

    if stale?(last_modified: @sharings.first&.updated_at)
      render json: { sharings: @sharings, total: @sharings.size }
    end
  end

  def show
    if stale?(last_modified: @sharing.updated_at)
      render json: @sharing
    end
  end

  def create
    valid_params = params.permit(:print_book_id)
    print_book = PrintBook.find_by id: params[:print_book_id]
    not_found! if print_book.nil?
    forbidden! I18n.t('api.errors.forbidden.print_book_not_for_share') unless print_book.shared?

    valid_params.merge!(receiver_id: current_user.id, holder_id: print_book.holder_id, book_id: print_book.book_id)
    sharing = Sharing.create! valid_params
    render json: sharing, status: :created
  end

  def accept
    forbidden! I18n.t('api.errors.forbidden.not_the_holder') unless @sharing.holder_id == current_user.id
    @sharing.accept
    @sharing.save
    render json: @sharing, status: :created
  end

  def reject
    forbidden! I18n.t('api.errors.forbidden.not_the_holder') unless @sharing.holder_id == current_user.id
    @sharing.reject
    @sharing.save
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
    @sharing.borrow
    @sharing.save
    @print_book.share_to current_user, @sharing
    render json: @sharing, status: :created
  end

  private

  def find_sharing
    @sharing = Sharing.find_by id: params[:id]
    @print_book = @sharing&.print_book
  end
end
