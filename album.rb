require 'rubygems'
require 'open-uri'
require 'fileutils'
require 'nokogiri'
require 'webdrivers'
require 'selenium-webdriver'

class List

  def initialize
    # option: écrire le nom d'un groupe
    # va trouver tous les noms les plus proches (sont contenus dans url vérifié)
    #"https://www.azlyrics.com/a/a1.html"
    #"https://www.azlyrics.com/e/eminem.html",
    #"https://www.azlyrics.com/b/beatles.html",
    #"https://www.azlyrics.com/j/jackson.html",
    #{}"https://www.azlyrics.com/m/madonna.html",
    #{}"https://www.azlyrics.com/b/bobmarley.html",
    #{}"https://www.azlyrics.com/r/rihanna.html"
    url_band = [
      "https://www.azlyrics.com/e/eminem.html"
    ]

    n = (url_band.length)  -1
    0.upto(n) do |c|
      #
      #driver = browser()
      #wait = Selenium::WebDriver::Wait.new(:timeout => 10)
      page = Nokogiri::HTML(URI.open((url_band[c])))
      #page = driver.get(url_band[c])






      albums_titles = []
      album = "a"
      links = []
      title = " "

      i_albums = 1
      i_titles = 1
      c = 1

      while true

        path_album = "/html/body/div[2]/div/div[2]/div[4]/div[#{i_albums.to_s}]/b"

        album = find_album(page, path_album)
        puts "#{album}  ... #{i_albums}"
        i_titles = i_titles + 1
        i_albums = i_albums + 1

        title = " "



        while title != ""
          path_title = "/html/body/div[2]/div/div[2]/div[4]/div[#{i_titles.to_s}]/a"
          title = find_title(page, path_title)
          albums_titles << [album, title]
          i_titles = i_titles + 1
          i_albums = i_albums + 1
        end
        i_titles = i_titles - 1
        i_albums = i_albums - 1

        if title == "" && album == ""
          div = ""
          page.xpath("//*[@id='azlyrics_incontent_#{c}']").each { |e|
            div = e.to_s
          }


          if div == ""
            break
          end
          c = c + 1
        end
      end

      print("albums over")
      #puts albums_titles
    end
  end


  def find_album(page, path_album)
    album = ""
    page.xpath(path_album).each { |node|
      album = node.text
      puts "#{album} is album"
    }
    return album
  end

  def find_title(page, path_title)
    title = ""
    page.xpath(path_title).each { |node|
      title = node.text
      puts "#{title} is title"
    }
    puts "...#{title} #{path_title}"

    return title
  end


end

List.new

__END__
=begin
begin
  #pr.ndre l.s l..ns
  elements = driver.find_elements(:id,'listAlbum') #q.i s.nt s..s id=L.st.lb.m
  puts elements
  wait.until{elements}
  puts url_band[c]
rescue => e
  puts e.message
  puts url_band[c]
end

elements.each { |e|
  puts e
}
end





en m.th.d.s

if album
  album = e

end




begin
  element = driver.find_elements(:class,'listalbum-item')
  wait.until{element}
  link =  e.find_element(:tag_name,'a').attribute("href")
  links << link
rescue => error
  puts error.message
  puts "link"
  link = "no_link"
  puts url_band
  links << link
end

begin
  title = e.text
  actual_alb = album
  albums_titles << [title, album]
rescue => error
  puts error.message
  puts "title"
  title = "no_title"
  puts url_band
  titles << title
end


csv l.st alb.m t.tl.s




def browser()
  #https://stackoverflow.com/questions/13082656/how-might-i-simulate-a-private-browsing-experience-in-watir-selenium
  profile = Selenium::WebDriver::Firefox::Profile.new
  profile['browser.privatebrowsing.dont_prompt_on_enter'] = true
  profile['browser.privatebrowsing.autostart'] = true

  #https://www.browserstack.com/docs/automate/selenium/firefox-profile#ruby
  options = Selenium::WebDriver::Firefox::Options.new(profile: profile)

  #options = Selenium::WebDriver::Options.firefox #ch..se f.r.f.x
  options = Selenium::WebDriver::Firefox::Options.new(args: ['-headless']) #br.ws.r h..dl.ss m.de
  # erreur Net::ReadTimeout with #<TCPSocket:(closed)> w.ll w..t 120s
  #https://github.com/SeleniumHQ/selenium/issues/7563
  client = Selenium::WebDriver::Remote::Http::Default.new
  client.read_timeout = 120
  driver = Selenium::WebDriver.for(:firefox, options: options)

  return driver
end
end
=end
