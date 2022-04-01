module JsonApiParams
  # Parses the attributes from the params in the request and makes them available as
  # params[type]
  def self.convert(params)
    return unless params['data']

    data = params['data'].to_unsafe_hash

    type = data[:type]
    attributes = data.fetch(:attributes, {})

    params[type] = ActionController::Parameters.new(attributes)
  end
end
