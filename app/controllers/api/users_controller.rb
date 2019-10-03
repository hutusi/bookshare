class Api::UsersController < Api::BaseController
  before_action :find_user, only: [:show, :update]

  def show
    if stale?(last_modified: @user.updated_at)
      render json: @user
    end
  end
  
  # register / sign up
  def create
    valid_params = params.permit(:email)
    user = PrintBook.create! valid_params
    render json: user, status: :created
  end

  # login / sign in
  def create_sesssion
  end

  def update
    valid_params = params.permit(:email)
    @user.update! valid_params
    render json: @user, status: :ok
  end

private
  def find_user
    @user = User.find_by id: params[:id]
  end
end
