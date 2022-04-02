class ModelErrorSerializer
  def initialize(model)
    @model = model
  end

  def as_json
    {
      errors: errors_json,
    }
  end

  private

  class ErrorObject
    def self.create(pointer:, detail:)
      {
        source: { pointer: pointer },
        detail: detail,
      }
    end
  end

  def errors_json
    build_errors_for_model do |attribute, message|
      ErrorObject.create(
        pointer: "/data/attributes/#{attribute}",
        detail: message
      )
    end
  end

  def build_errors_for_model
    @model.errors.messages.flat_map do |attribute, error_messages|
      error_messages.map do |message|
        yield attribute, message
      end
    end
  end
end
