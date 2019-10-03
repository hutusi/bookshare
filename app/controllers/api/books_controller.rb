class Api::BooksController < Api::BaseController
  before_action :find_book, only: [:show, :update, :destroy]
  
  def index
    @books = Book.all.order(updated_at: :desc)

    if stale?(last_modified: @books.first&.updated_at)
      render json: { books: @books, total: @books.size }
    end
  end

  def show
    if stale?(last_modified: @book.updated_at)
      render json: @book
    end
  end
  
  def create
    valid_params = params.permit(:title, :subtitle, :author, :publisher,
      :intro, :isbn, :cover_url, :douban_id)
      valid_params.merge!(created_by: current_user.id)
    book = Book.create! valid_params
    render json: book, status: :created
  end

  def update
    forbidden! I18n.t('api.errors.forbidden.not_the_creator') unless @book.creator == current_user
    valid_params = params.permit(:title, :subtitle, :author, :publisher,
      :intro, :isbn, :cover_url, :douban_id)
    @book.update! valid_params
    render json: @book, status: :ok
  end

  def destroy
    forbidden! I18n.t('api.errors.forbidden.not_the_creator') unless @book.creator == current_user
    @book.destroy!
    render json: {}, status: :ok
  end

private
  def find_book
    @book = Book.find_by id: params[:id]
  end
end
