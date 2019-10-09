# frozen_string_literal: true

class ApiAuthenticationStrategy < Warden::Strategies::Base
  def valid?
    provider.present? && uid.present?
  end

  def authenticate!
    identity = Identity.find_by(provider: provider, uid: uid)

    if identity && identity.user
      success!(identity.user)
    else
      fail!(I18n.t('api.auth.invalid_provider_or_uid'))
    end
  end

  private

  def provider
    params[:provider]
  end

  def uid
    params[:uid]
  end

  # def uid
  #   env['HTTP_AUTHORIZATION'].to_s.remove('Bearer ')
  # end
end
