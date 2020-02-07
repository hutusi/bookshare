# frozen_string_literal: true

class Api::PrintBooksController < Api::BaseController
  before_action :find_print_book, only: [:show, :update, :destroy, :update_property, :update_status]

  # TODO: paginate
  def index
    @print_books = PrintBook.all.order(updated_at: :desc)

    if stale?(last_modified: @print_books.first&.updated_at)
      render json: { print_books: @print_books, total: @print_books.size }
    end
  end

  def for_share
    @print_books = PrintBook.for_share.order(updated_at: :desc)

    if stale?(last_modified: @print_books.first&.updated_at)
      render json: { print_books: @print_books, total: @print_books.size }
    end
  end

  def for_borrow
    @print_books = PrintBook.for_borrow.order(updated_at: :desc)

    if stale?(last_modified: @print_books.first&.updated_at)
      render json: { print_books: @print_books, total: @print_books.size }
    end
  end

  def search_by
    @print_books = PrintBook.where(book_id: params[:book_id],
                                   owner_id: params[:owner_id]).order(updated_at: :desc)

    render json: { print_books: @print_books, total: @print_books.size }
  end

  def show
    if stale?(last_modified: @print_book.updated_at)
      render json: @print_book
    end
  end

  def create
    valid_params = params.permit(:book_id, :description)
    valid_params.merge!(owner_id: current_user.id, holder_id: current_user.id,
                        creator_id: current_user.id)
    forbidden! I18n.t('api.errors.print_book_duplicates') if PrintBook.exists? owner_id: current_user.id,
                                                                               book_id: valid_params[:book_id],
                                                                               description: valid_params[:description]
    print_book = PrintBook.create! valid_params
    render json: print_book, status: :created
  end

  def update
    valid_params = params.permit(:description, :property)
    forbidden! I18n.t('api.errors.forbidden.not_the_owner') unless @print_book.owner == current_user
    @print_book.update! valid_params
    render json: @print_book, status: :ok
  end

  def update_property
    valid_params = params.permit(:property)
    forbidden! I18n.t('api.errors.forbidden.not_the_owner') unless @print_book.owner == current_user
    @print_book.update! valid_params
    render json: @print_book, status: :ok
  end

  def update_status
    valid_params = params.permit(:status)
    forbidden! I18n.t('api.errors.forbidden.not_the_holder') unless @print_book.holder == current_user
    @print_book.update! valid_params
    render json: @print_book, status: :ok
  end

  def destroy
    @print_book.destroy!
    render json: {}, status: :ok
  end

  private

  def find_print_book
    @print_book = PrintBook.find_by id: params[:id]
  end
end
