require_relative 'frequency_scrapper'
require_relative 'own_voc'
require_relative 'title_lyrics_scrapper'
require_relative 'test_count'
require_relative 'select'

class Application

  def initialize
    while true
      puts `clear`
      puts "Welcome to 'It sounds like my vocab!'
      __________________________________________________________________
      If you want to scrap the data, '1' and 'enter'
      If you want to choose the vocab, '2' and 'enter'
      If you want score the songs already in the database, '3' and enter
      If you want to find your next song, '4' and 'enter'
      Entire run, '5' and 'enter'
      If you want to leave, 'ctrl + z' ('ctrl + x or c' in Mac) or '6'
      __________________________________________________________________"
      puts "When beginning with this program, press every keys in order (1,2,3,4)
Of course wait until you see that this action is finished before pressing other keys ;)"
      puts "1, 2, 3, 4, 5 or 6 ? >"

      key = gets.chomp.to_i

      case key
      when 1

        `clear`
        go_main_scrapper()

      when 2

        `clear`
        print "Scrapping: '1'
If you want to add your own (console writing): '2'
>"
        p = gets.chomp

        if p == "1"
          go_frequency_scrapper()
        end
        if p == "2"
          go_choose_own_voc()
        end

      when 3

        `clear`
        go_get_scores()

      when 4

        `clear`
        go_choosing_songs_to_learn()

      when 5

        go_frequency_scrapper()
        go_main_scrapper()
        go_get_scores()
        go_choosing_songs()

      when 6

        exit()

      end

    end
  end

  def go_frequency_scrapper()
    FrequencyScrapper.new
  end

  def go_choose_own_voc()
    PersonalVocabulary.new
  end

  def go_main_scrapper()
    MainScrapper.new
  end

  def go_get_scores()
    GetScores.new
  end

  def go_choosing_songs_to_learn()
    ChoosingSongsToLearn.new
  end

end
