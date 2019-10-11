# frozen_string_literal: true

class ApiAuthenticationStrategy < Warden::Strategies::Base
  def valid?
    api_token.present?
  end

  def authenticate!
    user = User.find_by(api_token: api_token)

    if user
      success!(user)
    else
      fail!(I18n.t('auth.api.invalid_api_token'))
    end
  end

  private

  def api_token
    params[:api_token]
  end
end
