class CreateTrackScores < ActiveRecord::Migration[7.0]
  def change
    create_table :track_scores do |t|
      t.integer :track_word_occurence

      t.timestamps
    end
  end
end
