# frozen_string_literal: true

# https://developers.weixin.qq.com/miniprogram/dev/api-backend/open-api/login/auth.code2Session.html
# GET https://api.weixin.qq.com/sns/jscode2session?appid=APPID&secret=SECRET&js_code=JSCODE&grant_type=authorization_code

class WechatAuthenticationStrategy < Warden::Strategies::Base
  def valid?
    code.present?
  end

  def authenticate!
    wechat_login

    unless @wechat_params[:errcode] == 0
      fail!(I18n.t('auth.wechat.login_failed', errcode: @wechat_params[:errcode], errmsg: @wechat_params[:errmsg]))
      return
    end

    provider = 'wechat'
    uid = @wechat_params[:openid]
    identity = Identity.find_by(provider: provider, uid: uid)

    if identity&.user
      success!(identity.user)
    else
      # new user:
      user = User.create_by_wechat @wechat_params
      if user.present?
        success!(user)
      else
        fail!(I18n.t('auth.wechat.create_user_failure'))
      end
    end
  end

  private

  def wechat_login
    url = 'https://api.weixin.qq.com/sns/jscode2session'
    params[:appid] = ENV['WECHAT_APP_ID']
    params[:secret] = ENV['WECHAT_APP_SECRET']
    params[:js_code] = code
    params[:grant_type] = 'authorization_code'

    response = Faraday.get url, params
    @wechat_params = JSON.parse(response.body).symbolize_keys
  end

  def code
    params[:js_code]
  end

  # def uid
  #   env['HTTP_AUTHORIZATION'].to_s.remove('Bearer ')
  # end
end
