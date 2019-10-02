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
    deal_params = params.permit(:type, :print_book_id, :location)
    print_book = PrintBook.find_by id: params[:print_book_id]
    not_found! if print_book.nil?

    deal_params.merge!(sponsor_id: current_user.id, book_id: print_book.book_id)
    deal = Deal.create! deal_params
    render json: deal, status: :created
  end

  def update
    deal_params = params.permit(:location, :status)
    @deal.update! deal_params
    render json: @deal, status: :ok
  end

  def destroy
    @deal.destroy!
    render status: :ok
  end

private
  def find_deal
    @deal = Deal.find_by id: params[:id]
  end
end
