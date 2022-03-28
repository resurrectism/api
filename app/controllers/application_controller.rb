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

    render json: json_api_bad_request('not logged in'), status: :unauthorized
  end

  def convert_json_api_request
    return if request.headers['Content-Type'] != 'application/vnd.api+json'

    ConvertJsonApiParams.call(params)
  end

  def json_api_errors(*errs)
    { errors: errs }
  end

  def json_api_bad_request(title)
    json_api_errors({ title: title, status: :bad_request })
  end

  def json_api_not_found(title)
    json_api_errors({ title: title, status: :not_found })
  end
end
