class ApplicationController < ActionController::API
  include JSONAPI::ActsAsResourceController

  def json_api_errors(*errs)
    { errors: errs.map { |err| JSONAPI::Error.new(err) } }
  end
end
