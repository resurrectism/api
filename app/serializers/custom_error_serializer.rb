class CustomErrorSerializer
  include SerializableError

  attr_reader :errors

  def initialize(*errors)
    @errors = errors
  end
end
