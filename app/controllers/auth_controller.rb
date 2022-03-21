class AuthController < ApplicationController
  skip_before_action :authorized

  def login
    user = User.find_by(email: auth_params[:email])

    if user.nil?
      render json: json_api_not_found('email not found'), status: :unauthorized
      return
    end

    unless user.authenticate(auth_params[:password])
      render json: json_api_bad_request('password mismatch'), status: :unauthorized
      return
    end

    tokens, base64_string = issue_tokens(user)
    user.update(refresh_token: base64_string)

    render json: { data: { attributes: tokens } }
  end

  def refresh_token
    token = refresh_token_params[:refresh_token]

    decoded_refresh_token = Auth.decode_refresh_token(token)
    user = User.find_by(refresh_token: decoded_refresh_token['refresh_token'])

    raise InvalidRefreshTokenError if user.nil?

    tokens, base64_string = issue_tokens(user)
    user.update(refresh_token: base64_string)

    render json: { data: { attributes: tokens } }
  rescue JWT::DecodeError, InvalidRefreshTokenError
    render json: json_api_bad_request('refresh_token is invalid'), status: :unauthorized
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

  def issue_tokens(user)
    access_token = Auth.issue_access_token(user: user.id)

    base64_string = Auth.random_base64
    refresh_token = Auth.issue_refresh_token(refresh_token: base64_string)

    [{ access_token: access_token, refresh_token: refresh_token }, base64_string]
  end

  class InvalidRefreshTokenError < StandardError; end
end
