class FreqDictionary < ApplicationRecord
  has_many :track_score_freq_dictionaries
  has_many :track_scores, through: :track_score_freq_dictionaries

  validates :freq_rank,uniqueness: true, presence: true
  validates :word, presence: true, uniqueness: true
  validates :language, presence: true
end
