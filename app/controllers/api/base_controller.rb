# frozen_string_literal: true

class ApiException < RuntimeError
  attr_accessor :status, :message

  def initialize(status, message)
    self.status = status
    self.message = message
  end

  def to_s
    "ApiException==> status:#{status},message:#{message}."
  end
end

class Api::BaseController < ActionController::API
  include Pundit
  respond_to :json
  before_action :authenticate_api!

  rescue_from Exception, with: :unknown_error_handle
  rescue_from ApiException, with: :api_error_handle

  rescue_from Pundit::NotAuthorizedError do |e|
    # TODO: FIXME
    # message = e.reason ? I18n.t("pundit.errors.#{e.reason}") : e.message
    message = e.message
    render json: { message: message }, status: :forbidden
  end

  rescue_from AASM::InvalidTransition do |exception|
    render json: { message: exception.message }, status: :forbidden
  end

  def authenticate_api!
    warden.authenticate!(:api)
  end

  def not_found!
    raise ApiException.new 404, "Not found!"
  end

  def forbidden!(message)
    raise ApiException.new 403, "Forbidden! #{message}"
  end

  def api_error_handle(exception)
    Rails.logger.warn exception
    render status: exception.status, json: { message: exception.message }
  end

  def unknown_error_handle(exception)
    Rails.logger.warn exception
    render status: 500, json: { message: "Server intrnal error!" }
  end

  def page
    params[:page] || 1
  end

  def per_page
    @per_page ||= (params[:per_page] || 25)
  end

  def pagination_dict(collection)
    {
      current_page: collection.current_page,
      next_page: collection.next_page,
      prev_page: collection.prev_page,
      total_pages: collection.total_pages,
      total_count: collection.total_count,
      per_page: @per_page
    }
  end

  # def test
  #   Rails.logger.debug params
  #   # http://douban.uieee.com/v2/book/isbn/9787505715660
  #   url = "http://douban.uieee.com/v2/book/isbn/#{params[:isbn]}"
  #   response = Faraday.get url
  #   json = JSON.parse(response.body)
  #   Rails.logger.debug json
  #   render status: 200, json: json
  # end
end
