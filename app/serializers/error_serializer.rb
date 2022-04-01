class ErrorSerializer
  def initialize(model)
    @model = model
  end

  def as_json
    {
      errors: errors_json,
    }
  end

  class ErrorObject
    def self.in_primary_resource(pointer:, detail:, code: nil)
      {
        source: { pointer: pointer },
        detail: detail,
        code: code,
      }.compact
    end
  end

  private

  def errors_json
    build_errors_for(@model) do |attribute, message|
      ErrorObject.in_primary_resource(
        pointer: "/data/attributes/#{attribute}",
        detail: message
      )
    end
  end

  def build_errors_for(model)
    model.errors.messages.flat_map do |attribute, error_messages|
      error_messages.map do |message|
        yield(attribute, message)
      end
    end
  end
end
