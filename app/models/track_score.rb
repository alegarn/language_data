class TrackScore < ApplicationRecord
  has_many :track_score_freq_dictionaries
  has_many :freq_dictionaries, through: :track_score_freq_dictionaries
  belongs_to :track

  validates :track_word_occurence, presence: true
end
