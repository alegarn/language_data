class FreqDictionary < ApplicationRecord
  has_many :track_score_freq_dictionaries
  has_many :track_scores, through: :track_score_freq_dictionaries

  validates :freq_rank,uniqueness: true, presence: true
  validates :word, presence: true, uniqueness: true
  validates :language, presence: true

  attr_accessor :words, :track_word_occurence, :computed_tracks_scores

  #https://medium.com/@yassimortensen/simple-search-form-in-rails-8483739e4042


  def self.search_words(search)
    unless search.nil?
      complete_list = search.downcase.split(' ')
      words = Hash.new
      complete_list.map { |word|
        from_list_word = self.find_by_sql("\
          SELECT fd.id, fd.word \
          FROM freq_dictionaries AS fd \
          WHERE fd.word LIKE '%#{word}'")[0]
          unless from_list_word.nil?
            words.store(:"#{from_list_word.word}", from_list_word)
          end
        }
      return words
    end
  end

  def self.search_track_word_occurence(words, genre)
    tracks_words_occurences = {}
    genre = genre.gsub("'", "%")
    words.each { |key, word_obj|
      needed_track_scores = Track.find_by_sql("\
      SELECT ts.track_id, ts.track_word_occurence, t.title, t.album, t.band, t.song_type \
      FROM track_score_freq_dictionaries AS tsfd, track_scores AS ts, tracks AS t \
      WHERE ts.id = tsfd.track_score_id AND ts.track_id = t.id AND t.song_type LIKE '%#{genre}' \
      AND #{word_obj.id} = tsfd.freq_dictionary_id ")
      needed_track_scores.each { |tso|
        if tso.track_word_occurence >= 2 
          track_id = tso.track_id
          track_title = tso.title.gsub('_', ' ')
          unless tracks_words_occurences[:"#{track_title}"].nil?
            multi_words_music = tracks_words_occurences[:"#{track_title}"] << [key, tso.track_word_occurence, tso]
            tracks_words_occurences.store(:"#{track_title}", multi_words_music)
          end
            if tracks_words_occurences[:"#{track_title}"].nil?
            tracks_words_occurences.store(:"#{track_title}", [[key, tso.track_word_occurence, tso]])
          end
        end
      }
    }
    return tracks_words_occurences
  end

  def self.calculate_track_scores(tracks_words_occurences)
    titles = {}
    computed_tracks_scores = []
      tracks_words_occurences.each do |title, track_title_w_obj_occ|
        score = 0
      track_title_w_obj_occ.each { |key, occ|
        score  = score + occ.to_i
      }
        computed_tracks_scores << [title, score, track_title_w_obj_occ[0][2] ]
    end
      computed_tracks_scores = computed_tracks_scores.sort_by { |k, v| -v}
      if computed_tracks_scores.length > 10
      return computed_tracks_scores[0,10]
    end
    return computed_tracks_scores
  end

end
