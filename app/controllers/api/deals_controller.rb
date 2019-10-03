class Api::DealsController < Api::BaseController
  before_action :find_deal, only: [:show, :update, :destroy]

  def index
    @deals = Deal.all.order(updated_at: :desc)

    if stale?(last_modified: @deals.first&.updated_at)
      render json: { deals: @deals, total: @deals.size }
    end
  end

  def show
    if stale?(last_modified: @deal.updated_at)
      render json: @deal
    end
  end
  
  def create
    type = params[:type].presence || ""
    create_by_type type
  end

  def update
    deal_params = params.permit(:location)
    @deal.update! deal_params
    render json: @deal, status: :ok
  end

  def destroy
    @deal.destroy!
    render json: {}, status: :ok
  end

protected
  def create_by_type(type)
    valid_params = params.permit(:print_book_id, :location)
    print_book = PrintBook.find_by id: params[:print_book_id]
    not_found! if print_book.nil?

    valid_params.merge!(type: type, sponsor_id: current_user.id, book_id: print_book.book_id)
    deal = Deal.create! valid_params
    render json: deal, status: :created
  end

private
  def find_deal
    @deal = Deal.find_by id: params[:id]
  end
end
