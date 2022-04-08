class ApplicationController < ActionController::API
  before_action :authorized
  before_action :convert_json_api_request, only: %i[create update]

  def auth_header
    request.headers['Authorization']
  end

  def access_token
    return unless auth_header

    token = auth_header.split[1]
    Auth.decode_access_token(token)
  rescue JWT::DecodeError
    nil
  end

  def current_user
    @current_user ||= User.find_by(id: access_token['user']) if access_token
  end

  def logged_in?
    !!access_token
  end

  def authorized
    return if logged_in?

    render status: :unauthorized
  end

  def convert_json_api_request
    return if request.headers['Content-Type'] != 'application/vnd.api+json'

    JsonApiParams.convert(params)
  end
end
