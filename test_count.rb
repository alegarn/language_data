require 'csv'
require 'rubygems'


def lyrics_parser(file_name)

  parser = File.open(file_name, "r")
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

    # chercher dans les lignes
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
  puts count.length
  count = count.sort_by{ |k,v| -v}#.to_h
  print count
  #columns = count.transpose
  lines = count.length
  print lines
  l = 0

  CSV.open("lyrics_per_voc_score.csv", "w") do |row|
    while l <= lines
      row << [count[l][0], count[l][1].to_s]
      l = l + 1
    end
  end
  # https://stackoverflow.com/questions/8183706/how-to-save-a-hash-into-a-csv
  # hash to csv

  return count
end

def perform
  print "file name?"
  puts ">"
  file_name = gets.chomp
  lyrics_parser(file_name)

end

perform
