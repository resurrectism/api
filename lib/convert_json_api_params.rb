module ConvertJsonApiParams
  def self.call(params)
    return unless params['data']

    data = params['data'].to_unsafe_hash
    type = data[:type]

    attributes = {}

    data.fetch(:attributes, {}).each do |attribute, value|
      attributes[attribute] = value
    end

    params[type] = ActionController::Parameters.new(attributes)
  end
end
