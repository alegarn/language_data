require 'rubygems'
require "csv"

rank = []
word = []

n = 0

CSV.open("words.csv", "r") do |row|
  row = row.to_a
  while n < 100
    rank << row[n][0]
    word << row[n][1]
    n = n + 1
  end
end

word_dict_freq = [rank, word]

id = []
total_found = []
word = []


n = 0

CSV.open("lyrics_per_voc_score.csv", "r") do |row|
  row = row.to_a
  while n < 54
    id << row[n][0]
    word << row[n][1]
    total_found << row[n][2]
    n = n + 1
  end
end

word_songs = [id, word, total_found]

print word_dict_freq
print word_songs
