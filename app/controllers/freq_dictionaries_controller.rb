class FreqDictionariesController < ApplicationController

  def index
    search = params[:search_w]
    selected_genre = params[:song_type]
    unless search.nil?
      @words = FreqDictionary.search_words(search)
      @tracks_word_occurences = FreqDictionary.search_track_word_occurence(@words, selected_genre)
      @tracks_scores = FreqDictionary.calculate_track_scores(@tracks_word_occurences)
    end

  end

  private

  def freq_dictionary_params
    params.require(:freq_dictionary).permit(:words, :tracks_scores)
  end

end
