class UsersController < ApplicationController
  skip_before_action :authorized, only: [:create]

  ALLOWED_PARAMS = %i[email password password_confirmation].freeze

  def create
    user = User.create(user_create_params)
    if user.valid?
        render status: :created
    else
      render json: ModelErrorSerializer.new(user).as_json, status: :unprocessable_entity
    end
  end

  def profile
    serializable_hash = UserSerializer.new(current_user).serializable_hash
    serializable_hash[:data].delete(:id)

    render json: serializable_hash.to_json, status: :ok
  end

  def user_create_params
    params.require(:user).permit(*ALLOWED_PARAMS)
  end
end
