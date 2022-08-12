class CreateTrackScoreFreqDictionaries < ActiveRecord::Migration[7.0]
  def change
    create_table :track_score_freq_dictionaries do |t|

      t.timestamps
    end
  end
end
