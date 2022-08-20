class ChoosingSongsToLearn

  def initialize
    #file_parser
    puts "write a file name '...'.csv (the words who are needed)?
    __________________________________________________________________
    Without change in the file, you can type: 'words'

    words.txt: top 101 for the most frequent english words, you can find it there: db/words/words.csv

    When you change it, think to change method: csv_voc_selected, variable: n
    __________________________________________________________________"
    puts ">"
    file_name_selected = gets.chomp

    # prends tous les n.ms des f.ch..rs, et en f..t une arr.y de n.ms
    files = count_files()
    l = files.length
    #(sc.re l.r.cs, the v.c)
    results = compare(songs_lyrics(files,l),selected_voc(file_name_selected))

    sort_lyrics_scores(results)
  end

  def count_files()
    Dir.chdir("./db/all_songs/")

    files = Dir.children(Dir.pwd)
    Dir.chdir("../../")
    puts Dir.pwd
    return files
  end



  def compare(word_songs, word_dict_freq)
    p = 0
    contain_lyrics_infos = []
    
    # comparer les mots à apprendre (soit les 10 premiers en anglais / voir le vocabulaire choisie), se trouvant dans les paroles
    # = lyrics = [[id, song_name, word, total_found], i][ ]
    word_songs.map do |lyrics|

      high_freq_voc_lyrics = lyrics_high_occurence(word_dict_freq, lyrics)

      score = 0

      high_freq_voc_lyrics.each {|number| score = score + number[1].to_i}
      high_freq_voc_lyrics.sort! { |a,b| b[1].to_i <=> a[1].to_i}

      # << song_name, [w.rdS (wr.tt.n),t.t.l_f..ndS (t.t.l_occ.rr.nce)], sc.re
      contain_lyrics_infos << [lyrics[1], high_freq_voc_lyrics, score]

      p = p + 1
    end

    return contain_lyrics_infos

  end


  # m.ts de gr.nde occ.r.nc d.ns l.s p.r.l.s
  def lyrics_high_occurence(word_dict_freq, lyrics)
    high_freq_voc_lyrics = []
    # trouver les mots de la liste, et les compter
    word_dict_freq[1].map do |row|
      i = 1
      # va chercher nombre de mots dans la liste
      while i < 50 # compt..r < nre de m.ts? (avec une l.m.te des 50 pr.m..rs, on arr.ve p.s au b..t du d.ct..nn..re => p..v..r tr..v.r le n.mbre de ch.que )
        # compter les mots à partir de 5 répétitions
        #lyrics = [[id, song_name, word, total_found], i][ ]
        if lyrics[2][i] == row && lyrics[3][i].to_i >= 5
          high_freq_voc_lyrics << [lyrics[2][i],lyrics[3][i]]
        end
        i = i + 1
      end
    end

    return high_freq_voc_lyrics
  end


  def songs_lyrics(files, l)
    word_songs = []
    i = 0
    while i < l #tous les dossiers d'all_songs
      #option pour choisir les chansons que l'on veut
      song_name = file_parser(i, files)
      song_name == "0" ? (break) : ()
      data = write_word_songs_csv(song_name , i)

      # data = [[id, song_name, word, total_found], i]
      # pour plusieurs, une boucle de plusieurs musiques
      word_songs << data[0]
      i = data[1]
    end

    return word_songs
  end

  def file_parser(i, files)
    song_name = "#{files[i]}"
    return song_name
  end

  def write_word_songs_csv(song_name, i)
    id = []
    total_found = []
    word = []
    n = 0

    CSV.open("./db/all_songs/#{song_name}/#{song_name}.txt_lyrics_per_voc_score.csv", "r") do |row|
      row = row.to_a
      while n < row.length
        id << row[n][0]
        word << row[n][1]
        total_found << row[n][2]
        n = n + 1
      end
      i = i + 1
    end

    return [[id, song_name, word, total_found], i]
  end


  def selected_voc(file_name)

    rank = []
    word = []

    changed_csv = csv_voc_selected(file_name, rank, word)
    # changed_csv[0] = rank
    # changed_csv[1] = word

    return word_dict_freq = [changed_csv[0], changed_csv[1]]
  end

  def csv_voc_selected(file_name, rank, word)
    n = 0

    CSV.open("./db/words/#{file_name}.csv", "r") do |row|
      row = row.to_a
      c = (row.length)
      while n < c
        rank << row[n][0]
        word << row[n][1]
        n = n + 1
      end
    end


    return [rank, word]
  end

  # sort_lyrics_scores(song_name, [w.rdS (wr.tt.n),t.t.l_f..ndS (t.t.l_occ.rr.nce)], sc.re)
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
    s = 0
    while s == 0
      puts "Exit? write 'y'"
      quit = gets.chomp
      if quit == "y"
        s = 1
      end
    end
  end

  # show(song_name, [w.rdS (wr.tt.n),t.t.l_f..ndS (t.t.l_occ.rr.nce)], sc.re)
  def show(list)
    o = 0
    list.map { |e|

      e[2] == 0 ? (break) : ()
      o = o + 1

      puts "En place #{o}:
      - #{e[0]} (#{e[2]} points)
      - #{e[1]}
      "
      o == 5 ? (break) : ()
    }
  end

end
