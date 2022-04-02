module SerializableError
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
    errors.map do |error|
      ErrorObject.create(
        pointer: "/data/attributes/#{error[:attribute]}",
        detail: error[:message]
      )
    end
  end
end
