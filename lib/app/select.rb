require 'rubygems'
require "csv"
require 'fileutils'

#require_relative 'frequency_scrapper'
#require_relative 'test_count'

def file_parser
  #choper des fichiers
  #dossier paroles
  Dir.chdir("./db/all_songs/")
  puts Dir.pwd
  puts Dir.children(Dir.pwd)
  # bon dossier, ensuite bon fichier (le bon path pour le dossier, en ayant aussi le nom du fichier txt)

end

def selected_voc(file_name)
  #travail à partir de /db/all_songs/
  Dir.chdir("../../db/words/")
  puts Dir.pwd + "selected"
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
  file_parser
  word_songs = []
  l = 0
  while l < 3
    print "what is the song name? (to quit: 0)"
    puts ">"
    puts Dir.pwd
    Dir.children(Dir.pwd)[l]
    song_name = "#{Dir.children(Dir.pwd)[l]}" #gets.chomp
    if song_name == "0"
      break
    end
    # pour plusieurs, une boucle de plusieurs musiques
    id = []
    total_found = []
    word = []

    n = 0

    CSV.open("#{song_name}/#{song_name}.txt_lyrics_per_voc_score.csv", "r") do |row|
      row = row.to_a
      while n < 54
        id << row[n][0]
        word << row[n][1]
        total_found << row[n][2]
        n = n + 1
      end
      l = l + 1
    end
    word_songs << [id,song_name, word, total_found]
  end

  return word_songs
end

def compare(word_songs, word_dict_freq)
  p = 0
  i = 1
  # comparer les mots à apprendre (soit les 10 premiers en anglais), se trouvant dans les paroles

  word_songs.map do |lyrics|
    words = []
    word_dict_freq[1].map do |row|
      i = 1
      while i < 9
        if lyrics[2][i] == row
          words << [lyrics[2][i],lyrics[3][i]]
        end
        i = i + 1
      end
    end

    score = 0
    words.each do |number|
      score = score + number[1].to_i
    end

    print "#{lyrics[1]}
    - #{words}
    - score de #{score} (english top 100) "
    p = p + 1
  end
end



def perform
  #file_parser

  print "write a file name '...'.csv (the words who are needed)?"
  puts ">"
  file_name_selected = gets.chomp
  compare(lyrics,selected_voc(file_name_selected))

end

perform
