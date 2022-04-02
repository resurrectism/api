class ModelErrorSerializer
  include SerializableError

  def initialize(model)
    @model = model
  end

  def errors
    @model.errors.messages.flat_map do |attribute, error_messages|
      error_messages.map { |message| { attribute: attribute, message: message } }
    end
  end
end
