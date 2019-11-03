# frozen_string_literal: true

class ApiException < Exception
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
  respond_to :json
  before_action :authenticate_api!, except: [:test]

  rescue_from Exception, with: :unknown_error_handle
  rescue_from ApiException, with: :api_error_handle

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
    p exception
    render status: exception.status, json: { message: exception.message }
  end

  def unknown_error_handle(exception)
    p exception
    render status: 500, json: { message: "Server intrnal error!" }
  end

  def test
    p params
    # https://douban.uieee.com/v2/book/isbn/9787505715660
    url = "https://douban.uieee.com/v2/book/isbn/#{params[:isbn]}"
    response = Faraday.get url
    json = JSON.parse(response.body)
    p json
  end
end
