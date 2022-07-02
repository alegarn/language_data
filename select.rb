require 'rubygems'
require "csv"



def selected_voc(file_name)
  rank = []
  word = []

  n = 0

  CSV.open("#{file_name}.csv", "r") do |row|
    row = row.to_a
    while n < 100
      rank << row[n][0]
      word << row[n][1]
      n = n + 1
    end
  end

  return word_dict_freq = [rank, word]
end



def lyrics
  print "what is the song name?"
  puts ">"
  song_name = gets.chomp
  # pour plusieurs, une boucle de musiques
  id = []
  total_found = []
  word = []

  n = 0

  CSV.open("#{song_name}.txt_lyrics_per_voc_score.csv", "r") do |row|
    row = row.to_a
    while n < 54
      id << row[n][0]
      word << row[n][1]
      total_found << row[n][2]
      n = n + 1
    end
  end

  return word_songs = [id, word, total_found]
end

def compare(word_songs, word_dict_freq)
  p = 0
  i = 1
  words = []
  # comparer les mots à apprendre (soit les 10 premiers en anglais), se trouvant dans les paroles


  word_dict_freq[1].map do |row|
      i = 1
      while i < 9
        if word_songs[1][i] == row
          words << [word_songs[1][i], word_songs[2][i]]
        end
        i = i + 1
      end
  end

  score = 0
  words.each do |number|
   score = score + number[1].to_i
  end

  print "#{words}: score de #{score} (english top 100) "
end



def perform
  print "write a file name '...'.csv (the words who are needed)?"
  puts ">"
  file_name_selected = gets.chomp

  compare(lyrics,selected_voc(file_name_selected))




end

perform
