class Api::BaseController < ActionController::API
  before_action :authenticate_user!
  
  def not_found!
  end
end
