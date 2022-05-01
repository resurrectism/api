class CreateExercises < ActiveRecord::Migration[7.0]
  def change
    create_table :exercises do |t|
      t.string :name
      t.references :track, null: false, foreign_key: true

      t.timestamps
    end

    add_index :exercises, %i[name track_id], unique: true
  end
end
