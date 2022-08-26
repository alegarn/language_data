class TrackScoreFreqDictionary < ApplicationRecord
  belongs_to :track_score
  belongs_to :freq_dictionary

  validates :track_score_id, presence: true
  validates :freq_dictionary_id, presence: true
end
