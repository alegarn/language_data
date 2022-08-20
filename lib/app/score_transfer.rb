class ScoreTransfer

  def initialize()
    move_all_score_files()
  end

  def move_all_score_files()

    puts Dir.getwd

    lyrics_coordinates = Hash.new
    to_artist_files_csv = []

    lyrics_coordinates = find_lyrics_coordinates(lyrics_coordinates)
    to_artist_files_csv = find_artists_coordinates(to_artist_files_csv)

    parse_songs(to_artist_files_csv, lyrics_coordinates)

    puts Dir.getwd

  end




  def find_lyrics_coordinates(lyrics_coordinates)

    Dir.chdir("db/all_songs")

    songs = Dir.children(Dir.pwd)

    songs.each { |song_dir|

      score_name = score_rename(song_dir)
      dir_name = dir_rename(song_dir)

      lyrics_coordinates[:"#{dir_name}"] = "db/all_songs/#{dir_name}/#{score_name}"
    }

    Dir.chdir("../../")

    return lyrics_coordinates

  end

  def find_artists_coordinates(to_artist_files_csv)

    Dir.chdir("artists")
    dir_artists = Dir.children(Dir.pwd)

    dir_artists.each { |artist_data|
      if artist_data.include?(".csv")
        to_artist_files_csv << "artists/#{artist_data}"
      end
    }

    Dir.chdir("../")

    return to_artist_files_csv

  end

  def score_rename(song_dir)

    Dir.chdir(song_dir)
    score_name = ""
    files = Dir.children(Dir.pwd)

    files.each { |song|
      if song.include?(".csv")
        score_name = song.gsub(/\s+/, " ").strip.gsub(" ", "_")
        if score_name == song
          Dir.chdir("../")

          return score_name
        end
        FileUtils.mv(song, score_name)
      end
    }

    Dir.chdir("../")

    return score_name
  end


  def dir_rename(song_dir)

    dir_name = song_dir.gsub(/\s+/, " ").strip.gsub(" ", "_")

    if dir_name == song_dir
      return song_dir
    end

    FileUtils.mv(song_dir, dir_name)

    return dir_name

  end



  def parse_songs(to_artist_files_csv, lyrics_coordinates)

    to_artist_files_csv.each { |p_to_csv|

      CSV.foreach("#{p_to_csv}") do |tree_row|

        album = tree_row[0]
        track = tree_row[1]
        artist = tree_row[2]

        lyrics_coordinates.each { |song_name_as_h_k, to_file_score|

          song_name = song_name_as_h_k.to_s.gsub('"', '')

          if song_name == track

            file_score_p = "#{to_file_score}"
            transfr_track = "artists/#{artist}/#{album}/#{track}"

            Dir.chdir(transfr_track)
            csv = Dir.glob("*.csv")[0]
            Dir.chdir("../../../../")

            if csv == nil
              begin
                FileUtils.mv file_score_p, transfr_track
                puts tree_row
                print " #{song_name_as_h_k} in artists/#{artist}/#{album}/#{track}"
              rescue => e
                puts e.message
                # GetScores.lyrics_parser(file_name) t.st_c..nt
              end

            end

          end
        }
      end
    }

  end

end



__END__

#_ sp.c.s

# les \n, "     esp.c.s    ", ' " '
#.to_s.gsub('"', '').strip.gsub(/\s+/, "_")


def transfr_tracks_score()
  songs_coordinate()
end



def songs_coordinate()
  coordinates = Hash.new

  Dir.chdir("artists")

  artists = Dir.children(Dir.pwd)

  # /
  artists.each { |artist|
    unless artist.include?(".csv")
      # /artist
      begin
        Dir.chdir("#{artist}")
      rescue => e
        e.message
        binding.pry
      end


      # https://stackoverflow.com/questions/6442473/how-to-create-hash-within-hash
      # https://ruby-doc.org/core-3.1.2/Hash.html#method-i-store
      coordinates.store(:"#{artist}", Hash.new)

      albums = Dir.children(Dir.pwd)
      albums.each { |album|
        unless album == " "
          # /artist/album
          begin
            Dir.chdir("#{album}")
          rescue => e
            puts e.message
            binding.pry
          end


          coordinates[:"#{artist}"].store(:"#{album}", [])

          songs = Dir.children(Dir.pwd)
          songs.each { |song|
            unless song == " "
              coordinates[:"#{artist}"][:"#{album}"] << song

              #transfer_song_csv(artist, album, song)


            end
          }
          Dir.chdir("../")
        end
      }
      Dir.chdir("../")
    end

  }

  return coordinates
end




# https://stackoverflow.com/questions/30718214/saving-hashes-to-file-on-ruby
# h.sh to f.le to h.sh


def transfer_song_csv(artist, album, song)

  Dir.chdir("../../../")
  current_location = Dir.getwd
  begin
    Dir.chdir("db/all_songs")
  rescue => e
    puts e.message
    binding.pry
  end

  lyrics_dir = Dir.children(Dir.pwd)
  lyrics_dir.each { |song_name|
    unless song_name == ".empty" || song_name == " "
      if song_name == song
        Dir.chdir("#{song_name}")
        lyrics_files = Dir.children(Dir.pwd)
        lyrics_files.each { |file_name|
          if file_name.include?(".txt_lyrics_per_voc_score.csv")
            puts "00000000000000000000000000000000000000"
            begin
              FileUtils.mv("#{file_name}", "#{current_location}/artists/#{artist}/#{album}/#{song}")

              Dir.chdir("../../artists/#{artist}/#{album}")

            rescue => e
              puts e.message
              binding.pry
            end

          end
        }
      end
    end
  }

end

end


CSV.foreach("path/to/file.csv", **options) do |row|
  t.tle = row[2]
  if t.tle == n.me
    FileUtils.mv("/jdzdb/dhaj/#{n.me}", "/r.w[0]/r.w[1]/t.tle")
  end
end

p.ss.d.r un d..ble ind.x

p.rs.r l'ind.x inv.r, r.tr..v.r le path s.ng/alb.m/art.st p.th art.st/alb.m/s.ng
name = file_name.replace(".txt_lyrics_per_voc_score", "")

prendre n'importe quel dossier d'all songs
st.ck n.m du d.ss..r
r.ntr.
d.ns h.s art et alb, v.l.e du t.tle
enr. t.tle, et alb et art
pr.nd ch.q csv
../../
va d.ns l.b/art. /"art" /"alb."/"s.ng"
csv
../../../../../










class DddRails

  Dir.chdir("lib/assets")

  artists = Dir.children(Dir.pwd)
  artists.each_with_index do |artist, index|

    if File.directory?("#{artist}") && artist != "words"
      puts "#{artist} artists"
      Dir.chdir("#{artist}")
      albums = Dir.children(Dir.pwd)

      albums.each { |album|
        puts "#{album} albums"
        Dir.chdir("#{album}")
        songs = Dir.children(Dir.pwd)

        songs.each do |song|
          puts "#{song} song"
          Dir.chdir("#{song}")

          Dir.glob("*.csv").each do |file|

            puts "#{file} un csv"

            parse_csv = CSV.parse(File.read("#{file}"), headers:true)
            parse_csv.each_with_index { |line, index|
              if index == 1
                puts "#{line}"
              end
            }

          end
          Dir.chdir("../")
          puts Dir.getwd

        end
        Dir.chdir("../")
        puts Dir.getwd

      }
      Dir.chdir("../")
      puts Dir.getwd

    end

    if artist == "words"
      Dir.chdir("#{artist}")
      Dir.glob("*.csv").each do |file|

        puts "#{file} un csv"

        parse_csv = CSV.parse(File.read("#{file}"), headers:true)
        parse_csv.each_with_index { |line, index|
          puts index
          puts "#{line}"
          if index > 1

            break

          end
        }
      end

      puts Dir.getwd
      Dir.chdir("../")
      puts Dir.getwd

    end

  end


  Dir.chdir("../")
  puts Dir.getwd

end
