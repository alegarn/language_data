class CreateTracks < ActiveRecord::Migration[7.0]
  def change
    create_table :tracks do |t|
      t.string :title
      t.string :song_type
      t.string :band
      t.string :album

      t.timestamps
    end
  end
end
