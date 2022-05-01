# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 20_220_420_092_538) do
  # These are extensions that must be enabled in order to support this database
  enable_extension 'plpgsql'

  create_table 'exercises', force: :cascade do |t|
    t.string 'name'
    t.bigint 'track_id', null: false
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index %w[name track_id], name: 'index_exercises_on_name_and_track_id', unique: true
    t.index ['track_id'], name: 'index_exercises_on_track_id'
  end

  create_table 'tracks', force: :cascade do |t|
    t.string 'language', null: false
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index ['language'], name: 'index_tracks_on_language', unique: true
  end

  create_table 'users', force: :cascade do |t|
    t.string 'email', null: false
    t.string 'password_digest', null: false
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.string 'refresh_token'
    t.index ['email'], name: 'index_users_on_email', unique: true
    t.index ['refresh_token'], name: 'index_users_on_refresh_token'
  end

  add_foreign_key 'exercises', 'tracks'
end
