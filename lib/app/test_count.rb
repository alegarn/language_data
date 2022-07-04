require 'csv'
require 'rubygems'

require_relative 'frequency_scrapper'
require_relative 'select'


def lyrics_parser(file_name)

  parser = File.open("./db/all_songs/#{file_name}.txt", "r")
  count = Hash.new #hash

  end_text = parser.each do |line|
    #supprimer la ponctuation
    # https://stackoverflow.com/questions/10073332/stripping-non-alphanumeric-chars-but-leaving-spaces-in-ruby
    words = line.downcase.gsub(/[^a-z0-9\s]/i, '').split(' ')

    # seulement des mots complets
    i = 0
    words.each do |new|
      if new == "m"
        words[i] = "am"
      end
      if new == "s"
        words[i] = "is"
      end
      i = i + 1
    end

    # chercher dans les lignes, détermine la note des paroles pour une recherche ("the = 9" la personne qui veut l'apprendre donne son score de 9 pour cette musique)
    c = 0
    words.map { |parse|
      # existe ou pas dans le hash? non, ajouter, mettre sa valeur à 1
      if count.empty? || count[parse] == nil
        count[parse] = 1
      end
      # existe, valeur +1
      if count[parse] > 0
        count[parse] = count[parse] + 1
      end
    }
  end

  #hash trié
  count = count.sort_by{ |k,v| -v}#.to_h
  #quand les paroles ont répété (le minimum) plusieurs (> 5) fois certains mots, elles deviennent efficace pour pouvoir apprendre ces nouveaux mots
  puts "'Song title' is great to learn:"
  count.each do |p|
    if p[1] >= 5
      puts "- #{p[0]}: #{p[1]} times"
    end
  end
  - #{count[0][0]}: found: #{count[0][1]}
  - #{count[1][0]}: found: #{count[1][1]}
  - #{count[2][0]}: found: #{count[2][1]}"

  #columns = count.transpose
  lines = count.length
  l = 0

  CSV.open("./db/all_songs/#{file_name}.txt_lyrics_per_voc_score.csv", "w") do |row|
    row << ["ID","WORD","FOUND"]
    while l <= lines - 1
      row << ["#{l+1}",count[l][0], count[l][1].to_s]
      l = l + 1
    end

  end
  # https://stackoverflow.com/questions/8183706/how-to-save-a-hash-into-a-csv
  # hash to csv

  return count
end

def perform
  print "file name? (txt)"
  puts ">"
  file_name = gets.chomp
  lyrics_parser(file_name)

end

perform
