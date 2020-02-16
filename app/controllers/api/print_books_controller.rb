# frozen_string_literal: true

class Api::PrintBooksController < Api::BaseController
  before_action :find_print_book, only: [:show, :update, :destroy, :update_property, :update_status]

  # TODO: paginate
  def index
    property = params[:property]
    if property != 'borrowable' && property != 'shared'
      forbidden! I18n.t('api.params.value_invalid', param: 'property',
                                                    value: property)
    end

    @print_books = PrintBook.where(property: property).order(updated_at: :desc)
                            .page(page).per(per_page)
    if stale?(last_modified: @print_books.maximum(:updated_at))
      render json: @print_books, each_serializer: PrintBookSerializer, meta: pagination_dict(@print_books)
    end
  end

  def for_share
    @print_books = PrintBook.all_shared.order(updated_at: :desc)
                            .page(page).per(per_page)

    if stale?(last_modified: @print_books.maximum(:updated_at))
      render json: @print_books, each_serializer: PrintBookSerializer, meta: pagination_dict(@print_books)
    end
  end

  def for_borrow
    @print_books = PrintBook.all_borrowable.order(updated_at: :desc)
                            .page(page).per(per_page)

    if stale?(last_modified: @print_books.maximum(:updated_at))
      render json: @print_books, each_serializer: PrintBookSerializer, meta: pagination_dict(@print_books)
    end
  end

  def search_by
    @print_books = PrintBook.where(book_id: params[:book_id],
                                   owner_id: params[:owner_id]).order(updated_at: :desc)

    render json: @print_books, each_serializer: PrintBookSerializer
  end

  def show
    if stale?(last_modified: @print_book.updated_at)
      render json: @print_book, serializer: PrintBookPreviewSerializer
    end
  end

  def create
    valid_params = params.permit(:book_id, :description)
    valid_params.merge!(owner_id: current_user.id, holder_id: current_user.id,
                        creator_id: current_user.id)
    forbidden! I18n.t('api.forbidden.print_book_duplicates') if PrintBook.exists? owner_id: current_user.id,
                                                                                  book_id: valid_params[:book_id],
                                                                                  description: valid_params[:description]
    print_book = PrintBook.create! valid_params
    render json: print_book, status: :created
  end

  def update
    valid_params = params.permit(:description, :property)
    forbidden! I18n.t('api.forbidden.not_the_owner') unless @print_book.owner == current_user
    @print_book.update! valid_params
    render json: {}, status: :ok
  end

  def update_property
    valid_params = params.permit(:property)
    forbidden! I18n.t('api.forbidden.not_the_owner') unless @print_book.owner == current_user
    @print_book.update! valid_params
    render json: {}, status: :ok
  end

  def update_status
    valid_params = params.permit(:status)
    forbidden! I18n.t('api.forbidden.not_the_holder') unless @print_book.holder == current_user
    @print_book.update! valid_params
    render json: {}, status: :ok
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
