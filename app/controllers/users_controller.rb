class UsersController < ApplicationController
  skip_before_action :authorized, only: [:create]

  def profile
    resource = JSONAPI::ResourceSerializer.new(UserResource).object_hash(UserResource.new(current_user, nil), nil)
    render json: { data: resource }, status: :ok
  end
end
