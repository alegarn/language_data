class AddForeignKeyToTrackScoreFreqDictionaries < ActiveRecord::Migration[7.0]
  def change
    add_reference :track_score_freq_dictionaries, :track_score, foreign_key: true
    add_reference :track_score_freq_dictionaries, :freq_dictionary, foreign_key: true
  end
end
