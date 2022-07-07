require 'pry'
require 'nokogiri'
require 'open-uri'
require 'pry'

#require_relative 'frequency_scrapper'
#require_relative 'select'
#require_relative 'test_count'

def lyrics_scrapper(url, song_links)
  titles = song_links[0]
  links = song_links[1]

  lyrics = []
  n = 0

  #parser les musiques

  while n < titles.length
    #moving ip
    if n%50 == 0 && n > 0
      change_ip
    end

    sleep(3)
    title = titles[n].downcase.gsub(/[^a-z0-9\s]/i, '').gsub(/[ ]/, '_')
    puts title
    page_url = url + links[n]
    puts page_url

    page = Nokogiri::HTML(URI(page_url).open)
    xpath = "/html/body/div[2]/div/div[2]/div[5]"
    song_lyrics = page.xpath(xpath)
    system 'mkdir', '-p', "./db/all_songs/#{title}"
    File.write("./db/all_songs/#{title}/#{title}.txt", "")

    song_lyrics.each do |node|
      line = node.text
      File.write("./db/all_songs/#{title}/#{title}.txt", "#{line}", mode:'a')
    end

    n = n + 1
  end


end

def page_parser
  # option: écrire le nom d'un groupe
  # va trouver tous les noms les plus proches (sont contenus dans url vérifié)
  url = "https://www.azlyrics.com/a/a1.html"
  page = Nokogiri::HTML(URI(url).open)
  titles = []
  links = []
  page_links = page.css('div.listalbum-item').css('a')

  page_links.each do |node|
    href = node.attribute('href').value
    links << href
    titles << node.text
  end

  return [titles, links]
end

def change_ip
  `nordvpn connect`
  sleep(30)
end

def perform
  puts "url à scrapper"
  url = "https://www.azlyrics.com"
  #juste un groupe
  pages = page_parser
  lyrics_scrapper(url, pages)
end

perform
