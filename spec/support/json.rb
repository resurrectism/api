def json_response
  OpenStruct.new(ActiveSupport::JSON.decode(@response.body))
end
