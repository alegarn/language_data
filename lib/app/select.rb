require 'rubygems'
require "csv"
require 'fileutils'
require 'pry'
#require_relative 'frequency_scrapper'
#require_relative 'test_count'


def selected_voc(file_name)
  #travail à partir de /db/all_songs/
  Dir.chdir("../../db/words/")
  puts Dir.pwd + " selected"
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



def lyrics(files, l)
  word_songs = []
  i = 0
  while i < l #tous les dossiers d'all_songs
    #option pour choisir les chansons que l'on veut
    song_name = file_parser(i, files)
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
      while n < row.length
        id << row[n][0]
        word << row[n][1]
        total_found << row[n][2]
        n = n + 1
      end
      i = i + 1
    end
    word_songs << [id,song_name, word, total_found]
  end

  return word_songs
end

def compare(word_songs, word_dict_freq)
  p = 0
  i = 1
  # comparer les mots à apprendre (soit les 10 premiers en anglais), se trouvant dans les paroles
  contain_lyrics_infos = []

  word_songs.map do |lyrics|

    high_freq_voc_lyrics = []

    # trouver les mots de la liste, et les compter
    word_dict_freq[1].map do |row|
      i = 1
      # va chercher nombre de mots dans la liste
      while i < 50
        # compter les mots à partir de 5 répétitions
        if lyrics[2][i] == row && lyrics[3][i].to_i >= 10
          high_freq_voc_lyrics << [lyrics[2][i],lyrics[3][i]]
        end
        i = i + 1
      end
    end

    score = 0
    high_freq_voc_lyrics.each do |number|
      score = score + number[1].to_i
    end

    high_freq_voc_lyrics.sort! { |a,b| b[1].to_i <=> a[1].to_i}

    contain_lyrics_infos << [lyrics[1], high_freq_voc_lyrics, score]

    p = p + 1
  end
  return contain_lyrics_infos
end

def show(list)
  o = 0
  list.map { |e|
    o = o + 1
  puts "En place #{o}:
  - #{e[0]} (#{e[2]} points)
  - #{e[1]}
  "
  if o == 5
    break
  end
  }
end

def sort_lyrics_scores(contain_lyrics_infos)

  contain_lyrics_infos.sort! { |a, b|
    b[2].to_i <=> a[2].to_i
  }

  print "Les 5 premières musiques (comptant le score):
  "
  show(contain_lyrics_infos)

  highest_total_words_number = contain_lyrics_infos.sort { |a, b|
    b[1].length <=> a[1].length
  }
  print "Les 5 premières (plus de vocabulaire):
  "
  show(highest_total_words_number)

end

def count_files
  Dir.chdir("./db/all_songs/")
  files = Dir.children(Dir.pwd)
  return files
end

def file_parser(i, files)
  song_name = "#{files[i]}"
  return song_name
end


def perform
  #file_parser

  print "write a file name '...'.csv (the words who are needed)?"
  puts ">"
  file_name_selected = gets.chomp

  files = count_files
  l = files.length

  results = compare(lyrics(files,l),selected_voc(file_name_selected))
  sort_lyrics_scores(results)
end

perform
