# frozen_string_literal: true

class Api::SessionsController < Api::BaseController
  skip_before_action :authenticate_api!

  def create_wechat
    valid_params = params.permit(:openid, :session_key, :unionid)
    identity = Identity.find_by(provider: :wechat, uid: params[:openid])
    if identity.present?
      render json: {user_id: identity.user_id}, status: :created
    else
      user = User.create_by_wechat valid_params
      render json: {user_id: user.id}, status: :no_content # 204
    end
  end
end
