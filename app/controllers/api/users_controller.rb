# frozen_string_literal: true

class Api::UsersController < Api::BaseController
  before_action :find_user, only: [:show, :update]

  def show
    return unless stale?(last_modified: @user.updated_at)

    render json: @user, status: :ok, serializer: UserSerializer
  end

  def update
    unless @user == current_user
      forbidden! I18n.t('api.forbidden.not_self_user')
    end
    valid_params = params.permit(:username, :email, :phone, :company,
                                 :bio, :contact,
                                 :nickname, :avatar, :gender, :country,
                                 :province, :city, :language)
    @user.update! valid_params
    render json: @user, status: :ok, serializer: UserSerializer
  end

  private

  def find_user
    @user = User.find_by id: params[:id]
  end
end
