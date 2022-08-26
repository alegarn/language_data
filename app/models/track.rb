class Track < ApplicationRecord
  has_many :track_scores
  
  validates :title, presence: true
  validates :song_type, presence: true
  validates :band, presence: true
  validates :album, presence: true
end
