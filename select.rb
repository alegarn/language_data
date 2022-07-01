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


def lyrics()

end

p = 0
i = 1
words = []
# comparer les mots à apprendre (soit les 10 premiers en anglais), se trouvant dans les paroles


word_dict_freq.map do |row|
  row.map do |compare|
    i = 1
    while i < 9
      if word_songs[1][i] == compare
        words << [word_songs[1][i], word_songs[2][i]]
      end
      i = i + 1
    end
  end
end

score = 0
words.each do |number|
 score = score + number[1].to_i
end

print "#{words}: score de #{score} (english top 100) "
