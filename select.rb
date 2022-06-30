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


i = 1
words = []
# comparer les mots à apprendre (soit les 10 premiers en anglais), se trouvant dans les paroles
while i < 5
  word_dict_freq.each do |row|
   print row[i]
    if word_songs[i][1] == row[i][1]
      words << [word_songs[i][1], word_songs[i][2]]
      puts words
    end
  end
  i = i + 1
end
puts words
