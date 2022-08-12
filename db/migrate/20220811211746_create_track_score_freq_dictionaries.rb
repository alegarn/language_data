class CreateTrackScoreFreqDictionaries < ActiveRecord::Migration[7.0]
  def change
    create_table :track_score_freq_dictionaries do |t|
      #t.belongs_to :freq_dictionary, index:true
      #t.belongs_to :track_score, index:true
      t.timestamps
    end
  end
end
