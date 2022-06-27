require 'rubygems'
require 'nokogiri'
require 'open-uri'
require 'csv'




def word_scrapper(url, page, table, rank, word)
  rank_path = "/html/body/div[3]/div[3]/div[5]/div[1]/table/tbody/tr[2]/td[1]"
  word_path = "/html/body/div[3]/div[3]/div[5]/div[1]/table/tbody/tr[2]/td[2]/a"
  xpaths = [rank_path, word_path]


  r = 2
  w = 0

  "0".upto("100") { |c|
    p = 0
    while p < xpaths.length
      page.xpath(xpaths[p]).each do |node|
        table[p] << node.text
        puts node.text
      end
      p = p + 1
    end

    r = r + 1
    w = w + 1
    rank_path = "/html/body/div[3]/div[3]/div[5]/div[1]/table/tbody/tr[#{r.to_s}]/td[1]"
    word_path = "/html/body/div[3]/div[3]/div[5]/div[1]/table/tbody/tr[#{r.to_s}]/td[2]/a[1]"
    xpaths = [rank_path, word_path]

  }
  create_csv(table, word)
end




# table to csv
def create_csv(table, word)
  columns = table.transpose
  lines = word.length
  l = 0

  CSV.open("words.csv", "w") do |row|
    while l <= lines
      row << [table[0][l], table[1][l]]
      l = l + 1
    end
  end
  print table

end

def perform
  url = "https://en.wiktionary.org/wiki/Wiktionary:Frequency_lists/TV/2006/1-1000"
  page = Nokogiri::HTML(URI(url).open)
  word = ["WORD"]
  rank = ["RANK"]
  table = [rank, word]

  # enter word number

  word_scrapper(url, page, table, rank, word)

end


#/html/body/div[3]/div[3]/div[5]/div[1]/table/tbody/tr[ +1 ]/td[1]
#/html/body/div[3]/div[3]/div[5]/div[1]/table/tbody/tr[ +1 ]/td[2]/a[ +1 ]
#/html/body/div[3]/div[3]/div[5]/div[1]/table/tbody/tr[3]/td[2]/a[1]
#/html/body/div[3]/div[3]/div[5]/div[1]/table/tbody/tr[4]/td[2]/a
