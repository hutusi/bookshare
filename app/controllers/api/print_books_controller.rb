# frozen_string_literal: true

class Api::PrintBooksController < Api::BaseController
  before_action :find_print_book, only: [:show, :update, :destroy,
                                         :update_property, :update_status]

  # TODO: paginate
  def index
    property = params[:property]
    if property != 'borrowable' && property != 'shared'
      forbidden! I18n.t('api.params.value_invalid', param: 'property',
                                                    value: property)
    end

    index_params = { property: property }
    index_params[:book_id] = params[:book_id] if params[:book_id].present?
    index_params[:owner_id] = params[:owner_id] if params[:owner_id].present?

    @print_books = PrintBook.where(index_params).order(updated_at: :desc)
                            .page(page).per(per_page)
    return unless stale?(last_modified: @print_books.maximum(:updated_at))

    render json: @print_books, each_serializer: PrintBookSerializer,
           meta: pagination_dict(@print_books)
  end

  def for_share
    @print_books = PrintBook.all_shared.order(updated_at: :desc)
                            .page(page).per(per_page)

    return unless stale?(last_modified: @print_books.maximum(:updated_at))

    render json: @print_books, each_serializer: PrintBookSerializer,
           meta: pagination_dict(@print_books)
  end

  def for_borrow
    @print_books = PrintBook.all_borrowable.order(updated_at: :desc)
                            .page(page).per(per_page)

    return unless stale?(last_modified: @print_books.maximum(:updated_at))

    render json: @print_books, each_serializer: PrintBookSerializer,
           meta: pagination_dict(@print_books)
  end

  def search
    property = params[:property]
    index_params = { property: property }
    index_params[:owner_id] = current_user.id if property == 'personal'

    keyword = params[:keyword]
    @print_books = PrintBook.where(index_params).by_keyword(keyword)
                            .page(page).per(per_page)

    render json: @print_books, each_serializer: PrintBookSerializer,
           meta: pagination_dict(@print_books)
  end

  def show
    return unless stale?(last_modified: @print_book.updated_at)

    render json: @print_book, serializer: PrintBookPreviewSerializer
  end

  def create
    valid_params = params.permit(:book_id, :description)
    valid_params.merge!(owner_id: current_user.id,
                        holder_id: current_user.id,
                        creator_id: current_user.id)
    print_book = PrintBook.create! valid_params
    render json: print_book, status: :created
  end

  def update
    authorize @print_book, :update?

    valid_params = params.permit(:description, :property, :region_code)
    SaveRegionJob.perform_later params[:region] if params[:region].present?
    @print_book.update! valid_params

    if params[:region_code].present?
      current_user.update!(region_code: params[:region_code])
    end
    render json: {}, status: :ok
  end

  def update_property
    authorize @print_book, :update_property?

    valid_params = params.permit(:property)
    @print_book.update! valid_params
    render json: {}, status: :ok
  end

  def update_status
    authorize @print_book, :update_status?

    valid_params = params.permit(:status)
    @print_book.update! valid_params
    render json: {}, status: :ok
  end

  def destroy
    authorize @print_book, :destroy?

    @print_book.destroy!
    render json: {}, status: :ok
  end

  private

  def find_print_book
    @print_book = PrintBook.find_by id: params[:id]
  end
end
