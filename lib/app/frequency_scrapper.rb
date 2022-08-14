#require "nokogiri"
#require "open-uri"
#require "csv"

class FrequencyScrapper

  def initialize
    #https://en.wiktionary.org/wiki/Wiktionary:Frequency_lists/TV/2006/1-1000

    url = "https://en.wiktionary.org/wiki/Wiktionary:Frequency_lists/A_Frequency_Dictionary_of_Contemporary_American_English"
    page = Nokogiri::HTML(URI(url).open)
    word = ["WORD"]
    rank = ["RANK"]
    table = [rank, word]

    # enter word number
    word_scrapper(url, page, table, table[1])

  end

  def word_scrapper(url, page, table, word)

    rank_path = 1
    word_path = "/html/body/div[3]/div[3]/div[5]/div[1]/ol/li[1]/a"
    #"/html/body/div[3]/div[3]/div[5]/div[1]/table/tbody/tr[2]/td[1]"

    xpaths = [rank_path, word_path]

    0.upto(4999) { |c|

      table = make_table(xpaths, page, table)
      #/html/body/div[3]/div[3]/div[5]/div[1]/table/tbody/tr[#{(c+3).to_s}]/td[1]
      rank_path = rank_path + 1
      word_path = "/html/body/div[3]/div[3]/div[5]/div[1]/ol/li[#{(c+2).to_s}]"
      #"/html/body/div[3]/div[3]/div[5]/div[1]/ol/li[#{(c + 3).to_s}]/a"
      xpaths = [rank_path, word_path]

    }
    create_csv(table, word)

  end

  def make_table(xpaths, page, table)
    #p = 0
    #  while p < xpaths.length

    table[0] << xpaths[0]
    table[1] << page.xpath(xpaths[1]).text
    #  end

    #  p = p + 1
    #end

    return table
  end

  # table to csv
  def create_csv(table, word)
    columns = table.transpose
    lines = word.length
    l = 0
    #./db/words/words.csv
    CSV.open("./words.csv", "w") do |row|
      while l <= lines
        row << [table[0][l], table[1][l]]
        l = l + 1
      end
    end
    print table

  end

end

FrequencyScrapper.new
