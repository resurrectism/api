class AuthController < ApplicationController
  def login
    user = User.find_by(email: auth_params[:email])

    if user.nil?
      render json: { errors: [{ status: '404', detail: 'Not Found' }] }
      return
    end

    if user.authenticate(auth_params[:password])
      jwt = Auth.issue(user: user.id)
      render json: { data: { attributes: { access_token: jwt } } }
    else
      render json: { errors: [{ status: '403', detail: 'Forbidden' }] }
    end
  end

  def logout; end

  private

  def auth_params
    # params.require(:data).require(:type)
    params.require(:data).require(:attributes).permit(:email, :password)
  end
end
