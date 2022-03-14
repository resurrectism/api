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
      # TODO: refactor into a method as it's used twice
      new_access_token = Auth.issue_access_token(user: user.id)

      base64_string = Auth.random_base64
      new_refresh_token = Auth.issue_refresh_token(refresh_token: base64_string)
      user.update(refresh_token: base64_string)

      render json: { data: { attributes: { access_token: new_access_token, refresh_token: new_refresh_token } } }
    else
      # TODO: refactor with early return if not authenticated
      render json: json_api_errors({ title: 'password mismatch', code: JSONAPI::BAD_REQUEST, status: :bad_request }),
             status: :unauthorized
    end
  end

  def refresh_token
    token = refresh_token_params[:refresh_token]

    begin
      decoded_refresh_token = Auth.decode_refresh_token(token)
      user = User.find_by(refresh_token: decoded_refresh_token['refresh_token'])
      user.update(refresh_token: nil)

      new_access_token = Auth.issue_access_token(user: user.id)

      base64_string = Auth.random_base64
      new_refresh_token = Auth.issue_refresh_token(refresh_token: base64_string)
      user.update(refresh_token: base64_string)

      render json: { data: { attributes: { access_token: new_access_token, refresh_token: new_refresh_token } } }
    rescue JWT::DecodeError
      render json: json_api_errors({ title: 'refresh_token is invalid', code: JSONAPI::BAD_REQUEST, status: :bad_request }),
             status: :unauthorized
    end
  end

  def logout
    # TODO: think about refactoring this into a method on the user
    current_user.update(refresh_token: nil)
  end

  private

  def auth_params
    params.require(:data).require(:attributes).permit(:email, :password)
  end

  def refresh_token_params
    params.require(:data).require(:attributes).permit(:refresh_token)
  end
end
