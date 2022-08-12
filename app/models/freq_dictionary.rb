class FreqDictionary < ApplicationRecord
  has_many :track_score_freq_dictionaries
  has_many :track_scores, through: :track_score_freq_dictionaries
end
