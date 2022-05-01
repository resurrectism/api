class ExercisesController < ApplicationController
  before_action :set_exercise, only: %i[show]

  def index
    @exercises = Exercise.all
    exercises_json = ExerciseSerializer.new(@exercises, is_collection: true).serializable_hash.to_json

    render json: exercises_json, status: :ok
  end

  def show
    exercise_json = ExerciseSerializer.new(@exercise).serializable_hash.to_json

    render json: exercise_json, status: :ok
  end

  private

  def set_exercise
    @exercise = Exercise.find(params[:id])
  end
end
