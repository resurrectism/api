class AuthController < ApplicationController
  skip_before_action :authorized

  def login
    user = User.find_by(email: auth_params[:email])

    if user.nil?
      errs = json_api_errors({ title: 'email not found', code: JSONAPI::RECORD_NOT_FOUND, status: :not_found })
      render json: errs, status: :unauthorized
      return
    end

    if user.authenticate(auth_params[:password])
      jwt = Auth.issue(user: user.id)
      render json: { data: { attributes: { access_token: jwt } } }
    else
      render json: json_api_errors({ title: 'password mismatch', code: JSONAPI::BAD_REQUEST, status: :bad_request }),
             status: :unauthorized
    end
  end

  def logout; end

  private

  def auth_params
    # params.require(:data).require(:type)
    params.require(:data).require(:attributes).permit(:email, :password)
  end
end
