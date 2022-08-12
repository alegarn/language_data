class AddForeignKeyToTrackScores < ActiveRecord::Migration[7.0]
  def change
    add_reference :track_scores, :track, foreign_key: true
  end
end
