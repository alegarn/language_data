# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

require "faker"

TrackScoreFreqDictionary.destroy_all
TrackScore.destroy_all
Track.destroy_all
FreqDictionary.destroy_all



10.times do
  track = Track.create(
    title: Faker::Lorem.word,
    song_type: Faker::Music.genre ,
    band: Faker::Music.band,
    album: Faker::Music.album
  )
end

10.times do
  i = 1
  freq_dictionary = FreqDictionary.create(
    freq_rank: i,
    word: Faker::String.random(length: 2..10),
    language: "english"
  )
  i = i + 1
end

30.times do
  track_score = TrackScore.create(
    track_id: Track.all.sample.id,
    track_word_occurence: rand(7..15)
  )
end

100.times do
  track_score_freq_dictionary = TrackScoreFreqDictionary.create(
    track_score_id: TrackScore.all.sample.id ,
    freq_dictionary_id: FreqDictionary.all.sample.id
  )
end
