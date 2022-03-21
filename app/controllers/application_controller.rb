class ApplicationController < ActionController::API
  include JSONAPI::ActsAsResourceController

  before_action :authorized

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

    render json: json_api_errors(title: 'not logged in', code: JSONAPI::BAD_REQUEST, status: :bad_request),
           status: :unauthorized
  end

  def json_api_errors(*errs)
    { errors: errs.map { |err| JSONAPI::Error.new(err) } }
  end

  def json_api_bad_request(title)
    json_api_errors({ title: title, code: JSONAPI::BAD_REQUEST, status: :bad_request })
  end

  def json_api_not_found(title)
    json_api_errors({ title: title, code: JSONAPI::RECORD_NOT_FOUND, status: :not_found })
  end
end
