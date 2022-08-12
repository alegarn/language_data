class AddConstraintToTracks < ActiveRecord::Migration[7.0]
  def change
    change_column_null :tracks, :title, false
    change_column_null :tracks, :song_type, false
    change_column_null :tracks, :band, false
  end
end
