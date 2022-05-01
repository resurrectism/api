# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

language_tracks = %w[JavaScript TypeScript]

language_tracks.each do |language|
  Track.create(language: language)
end

exercises = %w[HelloWorld]

Track.all.each do |track|
  exercises.each do |exercise|
    Exercise.create(name: exercise, track_id: track.id)
  end
end
