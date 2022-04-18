class CreateTracks < ActiveRecord::Migration[7.0]
  def change
    create_table :tracks do |t|
      t.string :language, null: false, unique: true

      t.timestamps
    end
  end
end
