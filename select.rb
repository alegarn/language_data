require 'rubygems'
require "csv"


word_dict_freq = []
word_songs = []
n = 0

CSV.open("words.csv", "r") do |row|
  row = row.to_a
  word_dict_freq << row
end

n = 0
CSV.open("lyrics_per_voc_score.csv", "r") do |row|
    row = row.to_a

    word_songs << row

end

print word_dict_freq
