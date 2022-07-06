require 'pry'
require 'nokogiri'
require 'open-uri'

#require_relative 'frequency_scrapper'
#require_relative 'select'
#require_relative 'test_count'

def lyrics_scrapper(url, song_links)
  titles = song_links[0]
  links = song_links[1]
  lyrics = []
  #parser la page
  title = titles[0].downcase.gsub(/[^a-z0-9\s]/i, '').gsub(/[ ]/, '_')
  puts title
  page_url = url + links[0]
  puts page_url

  page = Nokogiri::HTML(URI(page_url).open)
  xpath = "/html/body/div[2]/div/div[2]/div[5]"
  song_lyrics = page.xpath(xpath)
  system 'mkdir', '-p', "./db/all_songs/#{title}"
  File.write("./db/all_songs/#{title}/#{title}", "")

  song_lyrics.each do |node|
    line = node.text
    puts line
    File.write("./db/all_songs/#{title}/#{title}", "#{line}", mode:'a')
  end

end

def page_parser
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

def perform
  puts "url à scrapper"
  url = "https://www.azlyrics.com"
  #juste un groupe
  pages = page_parser
  lyrics_scrapper(url, pages)
end

perform
