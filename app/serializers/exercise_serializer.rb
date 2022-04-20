class ExerciseSerializer
  include JSONAPI::Serializer

  attributes :name
  belongs_to :track
end
