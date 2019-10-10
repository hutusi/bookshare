# frozen_string_literal: true

class Api::SessionsController < Api::BaseController
  skip_before_action :authenticate_api!

  # check wechat app docs:
  # https://developers.weixin.qq.com/miniprogram/dev/framework/open-ability/login.html
  def create_wechat
    warden.authenticate!(:wechat)
    render json: { user_id: current_user.id, api_token: current_user.api_token }, status: :created
  end
end
