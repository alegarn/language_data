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

puts Dir.getwd
Dir.chdir("lib/assets")


artists = Dir.children(Dir.pwd)

artists.each do |artist|
  if artist == "words"
    Dir.chdir("#{artist}")
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

    puts Dir.getwd
    Dir.chdir("../")
    puts Dir.getwd
  end
end

artists.each do |artist|

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
        track = Track.create(
          title: song,
          song_type: "0" ,
          band: artist,
          album: album
        )
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
        Dir.chdir("../")
        puts Dir.getwd

      end
      Dir.chdir("../")
      puts Dir.getwd

    }
    Dir.chdir("../")
    puts Dir.getwd

  end

end
