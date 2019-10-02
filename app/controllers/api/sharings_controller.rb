class Api::SharingsController < Api::DealsController
  before_action :find_sharing, only: [:create_request, :create_share, 
    :create_reject, :destroy_share, :create_accept]

  def index
    @sharings = Sharing.all.order(updated_at: :desc)

    if stale?(last_modified: @sharings.first&.updated_at)
      render json: { sharings: @sharings, total: @sharings.size }
    end
  end

  def create
    create_by_type 'Sharing'
  end

  def create_request
    forbidden! 'Book is not available.' unless @sharing.available?
    forbidden! 'You can not request a book belongs to yourself.' if @print_book.holder == current_user
    @sharing.request
    @sharing.applicant = current_user
    @sharing.save
    render json: @sharing, status: :created
  end

  def create_share
    forbidden! 'You are not holding the book.' unless @print_book.holder == current_user
    @sharing.share
    @sharing.save
    render json: @sharing, status: :created
  end

  def create_reject
    forbidden! 'You are not holding the book.' unless @print_book.holder == current_user
    @sharing.reject
    @sharing.applicant = nil
    @sharing.save
    render json: @sharing, status: :created
  end

  def destroy_share
    forbidden! 'You are not holding the book.' unless @print_book.holder == current_user
    @sharing.revert_share
    @sharing.save
    render json: @sharing, status: :ok
  end

  def create_accept
    forbidden! "You haven't request the book." unless @sharing.applicant == current_user
    @sharing.accept
    @sharing.save

    @print_book.holder = current_user
    @print_book.last_deal&.finish
    @print_book.last_deal = @sharing
    @print_book.save

    render json: @sharing, status: :created
  end

private
  def find_sharing
    @sharing = Sharing.find_by id: params[:id]
    @print_book = @sharing.print_book
  end
end
