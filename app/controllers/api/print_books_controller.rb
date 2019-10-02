class Api::PrintBooksController < Api::BaseController
  before_action :find_print_book, only: [:show, :update, :destroy]

  # todo: paginate
  def index
    @print_books = PrintBook.all.order(updated_at: :desc)

    if stale?(last_modified: @print_books.first&.updated_at)
      render json: { print_books: @print_books, total: @print_books.size }
    end
  end

  def show
    if stale?(last_modified: @print_book.updated_at)
      render json: @print_book
    end
  end
  
  def create
    book_params = params.permit(:book_id, :description)
    book_params.merge!(owner_id: current_user.id, holder_id: current_user.id, 
                       created_by: current_user.id)
    print_book = PrintBook.create! book_params
    render json: print_book, status: :created
  end

  def update
  end

  def destroy
  end

private
  def find_print_book
    @print_book = PrintBook.find_by id: params[:id]
  end
end
