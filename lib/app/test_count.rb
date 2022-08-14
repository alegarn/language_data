
# g.ve sc.re to d.t.b.se s.ngs
class GetScores

  def initialize
    print "file name? (a '.txt' type)"
    puts ">"

    files = count_files()
    l = files.length
    i = 0

    while i < l
      file_name = file_parser(i, files)
      lyrics_parser(file_name)
      i = i + 1
    end
    puts "Rate songs done"
    sleep(3.seconds)
  end

  # compte sur t..s les f.ch..rs
  def count_files()
    Dir.chdir("./db/all_songs/")
    files = Dir.children(Dir.pwd)
    Dir.chdir("../../")

    return files
  end

  def file_parser(i, files)
    song_name = "#{files[i]}"
    return song_name
  end

  def lyrics_parser(file_name)

    unless File.exists?("./db/all_songs/#{file_name}/#{file_name}.txt_lyrics_per_voc_score.csv")
      parser = File.open("./db/all_songs/#{file_name}/#{file_name}.txt", "r")
      count = Hash.new #hash

      count = processed_lyrics_to_parse(parser,count)

      #hash trié
      count = count.sort_by{ |k,v| -v}#.to_h
      #quand les paroles ont répété (le minimum) plusieurs (> 5) fois certains mots, elles deviennent efficace pour pouvoir apprendre ces nouveaux mots
      display_words(file_name, count)
      write_csv(file_name, count)
    end

  end

  def processed_lyrics_to_parse(parser, count)

    parser.each do |line|
      #supprimer la ponctuation
      # https://stackoverflow.com/questions/10073332/stripping-non-alphanumeric-chars-but-leaving-spaces-in-ruby
      words = line.downcase.gsub(/[^a-z0-9\s]/i, '').split(' ')
      # seulement des mots complets
      words = plain_words(words)
      # chercher dans les lignes, détermine la note des paroles pour une recherche ("the = 9" la personne qui veut l'apprendre donne son score de 9 pour cette musique)
      count = endword_numbers(words,count)
    end

    return count
  end

  def plain_words(words)

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

    return words

  end

  def endword_numbers(words,count)
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

    return count
  end

  def display_words(file_name, count)

    puts "That song: '#{file_name}' is great to learn:
    (number of times that words are contained in this song)"

    count.map do |p|
      if p[1] >= 5
        puts "- #{p[0]}: #{p[1]} times"
      end
    end

  end

  def write_csv(file_name, count)

    lines = count.length
    l = 0

    CSV.open("./db/all_songs/#{file_name}/#{file_name}.txt_lyrics_per_voc_score.csv", "w") do |row|
      row << ["ID","WORD","FOUND"]
      while l <= lines - 1
        row << ["#{l+1}",count[l][0], count[l][1].to_s]
        l = l + 1
      end
    end

  end
  # https://stackoverflow.com/questions/8183706/how-to-save-a-hash-into-a-csv
  # hash to csv

end
