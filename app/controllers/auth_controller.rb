class AuthController < ApplicationController
  skip_before_action :authorized, except: [:logout]
  before_action :convert_json_api_request, only: %i[login refresh_token]

  ALLOWED_LOGIN_PARAMS = %i[email password].freeze
  ALLOWED_REFRESH_TOKEN_PARAMS = %i[refresh_token].freeze

  REFRESH_TOKEN_PATH = %r{/users/(logout|refresh_token)}.freeze

  COMMON_COOKIE_OPTIONS = {
    domain: Rails.configuration.client_domain,
    httponly: true,
    secure: Rails.env.production?,
    same_site: :lax,
  }.freeze

  def login
    user = User.find_by(email: auth_params[:email])

    if user.nil? || !user.authenticate(auth_params[:password])
      render status: :unauthorized
      return
    end

    tokens, base64_string = issue_tokens(user)
    user.update(refresh_token: base64_string)

    auth_cookies_set(tokens)

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
    render status: :unauthorized
  end

  def logout
    current_user&.update(refresh_token: nil)

    cookies.delete(:access_token, domain: Rails.configuration.client_domain)
    cookies.delete(:refresh_token, domain: Rails.configuration.client_domain, path: REFRESH_TOKEN_PATH)
  end

  private

  def auth_cookies_set(tokens)
    cookies.encrypted[:access_token] = {
      value: tokens[:access_token],
      expires: Auth::EXPIRES_IN,
    }.merge(COMMON_COOKIE_OPTIONS)

    cookies.encrypted[:refresh_token] = {
      value: tokens[:refresh_token],
      expires: Auth::REFRESH_TOKEN_EXPIRES_IN,
      path: REFRESH_TOKEN_PATH,
    }.merge(COMMON_COOKIE_OPTIONS)
  end

  def auth_params
    params.require(:user).permit(*ALLOWED_LOGIN_PARAMS)
  end

  def refresh_token_params
    params.require(:user).permit(*ALLOWED_REFRESH_TOKEN_PARAMS)
  end

  def issue_tokens(user)
    access_token = Auth.issue_access_token(user: user.id)

    base64_string = Auth.random_base64
    refresh_token = Auth.issue_refresh_token(refresh_token: base64_string)

    [{ access_token: access_token, refresh_token: refresh_token }, base64_string]
  end

  class InvalidRefreshTokenError < StandardError; end
end
