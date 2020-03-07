# frozen_string_literal: true

class Api::BooksController < Api::BaseController
  before_action :find_book, only: [:show, :update, :destroy]

  def index
    books = Book.all.order(updated_at: :desc)
    if stale?(last_modified: books.maximum(:updated_at))
      render json: books, status: :ok, each_serializer: BookSerializer
    end
  end

  def show
    if stale?(last_modified: @book.updated_at)
      render json: @book, status: :ok, serializer: BookPreviewSerializer, scope: current_user
    end
  end

  def create
    forbidden! I18n.t('api.forbidden.method_not_allowed')
    # valid_params = permitted_params
    # valid_params[:creator_id] = current_user.id
    # book = Book.create! valid_params
    # render json: book, status: :created, serializer: BookPreviewSerializer
  end

  def update
    forbidden! I18n.t('api.forbidden.method_not_allowed')
    # forbidden! I18n.t('api.forbidden.not_the_creator') unless @book.creator == current_user
    # valid_params = permitted_params
    # @book.update! valid_params
    # render json: {}, status: :ok
  end

  def destroy
    forbidden! I18n.t('api.forbidden.method_not_allowed')
    # forbidden! I18n.t('api.forbidden.not_the_creator') unless @book.creator == current_user
    # @book.destroy!
    # render json: {}, status: :ok
  end

  def isbn
    isbn = params[:isbn].strip
    if isbn.size == 10
      book = Book.find_by(isbn10: isbn)
    elsif isbn.size == 13
      book = Book.find_by(isbn13: isbn)
    else
      forbidden! I18n.t('api.params.invalid_isbn', isbn: isbn)
    end

    book ||= Book.create_by_isbn(isbn, current_user)
    if book.present?
      render json: book, status: :ok, serializer: BookPreviewSerializer, scope: current_user
    else
      render json: {}, status: :not_found
    end
  end

  private

  def find_book
    @book = Book.find_by id: params[:id]
  end

  def permitted_params
    params.permit(:title, :subtitle, :author_id, :publisher_id,
                  :intro, :isbn, :cover, :douban_id)
  end
end
