# frozen_string_literal: true

class Api::UsersController < Api::BaseController
  before_action :find_user, only: [:show, :update]

  def show
    if stale?(last_modified: @user.updated_at)
      render json: @user, status: :ok, serializer: UserSerializer
    end
  end

  def update
    forbidden! I18n.t('api.errors.forbidden.not_self_user') unless @user == current_user
    valid_params = params.permit(:username, :email, :phone, :company, :bio, :contact,
                                 :nickname, :avatar, :gender, :country, :province, :city, :language)
    @user.update! valid_params
    render json: @user, status: :ok, serializer: UserSerializer
  end

  private

  def find_user
    @user = User.find_by id: params[:id]
  end
end
