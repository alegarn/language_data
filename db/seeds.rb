# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

require "faker"
require "csv"

TrackScoreFreqDictionary.destroy_all
TrackScore.destroy_all
Track.destroy_all
FreqDictionary.destroy_all

def dir_childrens()
  return Dir.children(Dir.pwd)
end

def show_enter(type)
  print "#{type}"
  Dir.chdir("#{type}")
end

def dir_left_show_path()
  Dir.chdir("../")
  puts Dir.getwd
end

def change_song_type(song_types, artist)
  genre = song_types[:"#{artist}"]
  return genre
end


puts Dir.getwd
Dir.chdir("lib/assets")

song_types = {:michael_jackson => 'pop', :madonna => 'dance',:the_beatles => "rock'n roll", :a1 => "pop-rock", :jose_gonzales => "indie-folk", :eminem => "rap"}

artists = dir_childrens()

artists.each do |artist|
  if artist == "words"
    show_enter(artist)
    print (" artist \n")
    Dir.glob("*.csv").each do |file|

      puts "#{file} un csv"

      parse_csv = CSV.parse(File.read("#{file}"), headers:true)

      parse_csv.each_with_index { |line, index|
        if index == parse_csv.size - 1
          break
        end

        freq_dictionary = FreqDictionary.create(
          freq_rank: index + 1 ,
          word: line[1],
          language: "english"
        )
      }

    end

    dir_left_show_path()
  end
end



artists.each do |artist|

  genre = change_song_type(song_types, artist)

  if File.directory?("#{artist}") && artist != "words"
    show_enter(artist)
    print (" artist \n")

    albums = dir_childrens()

    albums.each { |album|
      unless album == "a"
        show_enter(album)
        print(" album \n")
        songs = dir_childrens()
      end

      songs.each do |song|
        unless song == "a" || song == " "
          show_enter(song)
          print(" song \n")
          binding.pry
          track = Track.create!(
            title: song,
            song_type: "#{genre}",
            band: artist,
            album: album
          )
          binding.pry
          Dir.glob("*.csv").each do |file|

            puts "#{file} un csv"

            w = []
            o = []
            a = 0

            parse_csv = CSV.parse(File.read("#{file}"), headers:true)
            parse_csv.each_with_index { |line, index|
              if index == parse_csv.size - 1
                break
              end
              a = a + 1
              w << line[1]
              o << line[2]

            }
            0.upto((a-1)) do |word|

              begin
                search = FreqDictionary.find_by_word("#{w[word]}")

                unless search.nil?
                  binding.pry
                  track_score = TrackScore.create(
                    track_id: Track.last.id,
                    track_word_occurence: o[word]
                  )

                  track_score_freq_dictionary = TrackScoreFreqDictionary.create(
                    track_score_id: TrackScore.last.id ,
                    freq_dictionary_id: search.id
                  )

                end

              rescue => e
                puts e.message

              end


            end

          end
        end

        dir_left_show_path()

      end
      dir_left_show_path()

    }
    dir_left_show_path()

  end


end
