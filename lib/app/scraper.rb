#require 'open-uri'
#require 'fileutils'

#require 'webdrivers'
#require 'selenium-webdriver'

class MultiLyricScraper

  def initialize
    # option: écrire le nom d'un groupe
    # va trouver tous les noms les plus proches (sont contenus dans url vérifié)
    # "https://www.azlyrics.com/a/a1.html",
    #"https://www.azlyrics.com/e/eminem.html",
    #"https://www.azlyrics.com/b/beatles.html",
    #"https://www.azlyrics.com/j/jackson.html",
    #"https://www.azlyrics.com/m/madonna.html",
    #"https://www.azlyrics.com/b/bobmarley.html",
    #"https://www.azlyrics.com/r/rihanna.html"
    url_band = [
      "https://www.azlyrics.com/e/eminem.html"
    ]
    n = (url_band.length) - 1
    0.upto(n) do |c|
      #
      driver = browser()
      wait = Selenium::WebDriver::Wait.new(:timeout => 120)

      pages = discography_parser(c, driver, wait, url_band)
      driver = change_ip(driver, pages[2])
      #dr.v.r c.nt..n.ng the op.n br.ws.r
      lyrics_scrapper(driver, pages, pages[2])
    end

  end


  def browser()
    #https://stackoverflow.com/questions/13082656/how-might-i-simulate-a-private-browsing-experience-in-watir-selenium
    profile = Selenium::WebDriver::Firefox::Profile.new
    profile['browser.privatebrowsing.dont_prompt_on_enter'] = true
    profile['browser.privatebrowsing.autostart'] = true

    #https://www.browserstack.com/docs/automate/selenium/firefox-profile#ruby
    options = Selenium::WebDriver::Firefox::Options.new(profile: profile)

    wait = Selenium::WebDriver::Wait.new(:timeout => 10)

    #options = Selenium::WebDriver::Options.firefox #ch..se f.r.f.x
    options = Selenium::WebDriver::Firefox::Options.new(args: ['-headless']) #br.ws.r h..dl.ss m.de
    # erreur Net::ReadTimeout with #<TCPSocket:(closed)> w.ll w..t 120s
    #https://github.com/SeleniumHQ/selenium/issues/7563
    #https://github.com/SeleniumHQ/selenium/wiki/Ruby-Bindings#internal-timeouts
    client = Selenium::WebDriver::Remote::Http::Default.new
    client.read_timeout = 180
    #driver = Selenium::WebDriver.for :remote, http_client: client
    #https://www.faqcode4u.com/faq/181496/netreadtimeout-netreadtimeout-selenium-ruby
    driver = Selenium::WebDriver.for(:firefox, http_client: client, options: options)

    #https://stackoverflow.com/questions/72374955/failed-to-read-marionette-port-when-running-selenium-geckodriver-firefox-a


    #driver = Selenium::WebDriver.for(:firefox, options: options)

    return driver
  end


  def discography_parser(c, driver, wait, url_band)
    #  binding.pry

    #download_total_discography_page(band, url_band_str )
    page = driver.get(url_band[c])
    titles = []
    #albums_titles = []
    links = []

    elements = return_elements(driver, url_band, c)

    elements.each { |e|
      #en m.th.d.s

      #if album
      #  album = e

      #  end
      links = search_link(e, links, url_band)
      titles = search_title(e, titles, url_band)

    }

    #csv l.st alb.m t.tl.s

    return [titles, links, url_band[c]]

  end

  def return_elements(driver, url_band, c)
    begin
      #pr.ndre l.s l..ns
      elements = driver.find_elements(:class,'listalbum-item') #q.i s.nt s..s id=L.st.lb.m
      wait.until{elements}
      puts url_band[c]
      return elements
    rescue => e
      puts e.message
      puts url_band[c]
      return elements
    end
  end

  def search_link(e, links, url_band)
    begin
      link =  e.find_element(:tag_name,'a').attribute("href")
      links << link
      return links
    rescue => error
      puts error.message
      puts "link"
      link = "no_link"
      puts url_band
      links << link
      return links
    end

  end

  def search_title(e, titles, url_band)
    begin
      title = e.text
      #
      #actual_alb = album
      titles << title
      #albums_titles << [title, album]
      return titles
    rescue => error
      puts error.message
      puts "title"
      title = "no_title"
      puts url_band
      #
      titles << title
      return titles
    end
  end

  def lyrics_scrapper(driver, song_links, tab_url)
    titles = song_links[0]
    links = song_links[1]

    lyrics = []
    n = 0
    #parser les musiques
    while n < titles.length

      title = titles[n]
      page_url = links[n]


      #r..n if p.s le f.ch..r.txt and d.d.ns un f.ch..r => <> n.l  || il se tr..ve m..v..s f.ch..r
      unless File.exists?("./db/all_songs/#{title}/#{title}.txt") #&&
        #unless  Dir.entries("./db/all_songs/#{title}")[0] != nil #||
        #unless Dir.entries("./db/all_songs/#{title}")[0] == "#{title}.txt"
        #./db/all_songs/#{title}/ et oth.r th.n t.tle

        #moving ip
        if n%30 == 0 && n > 0
          # need to add the choice
          driver = change_ip(driver, tab_url)
        end

        song_lyrics = extract_song_lyrics(page_url, driver)
        create_file(title, song_lyrics)
        #  end
        #end



      end

      puts "#{page_url} extr.ct.d"
      n = n + 1
    end


  end



  def change_ip(driver, tab_url)

    begin
      driver.quit
      `nordvpn connect`
      sleep(rand(18..30))
    rescue => e
      puts e.message
      driver = browser()
      `nordvpn connect`
      sleep(rand(18..30))
    end

    begin
      driver = browser()
      driver.get(tab_url)
      sleep(10)
    rescue => e
      puts e.message
      driver = change_ip(driver, tab_url)
    end

    return driver
  end


  def extract_song_lyrics(page_url, driver)
    sleep(rand(1..5))
    begin
      driver.get(page_url)
      xpath = "/html/body/div[2]/div/div[2]/div[5]"
      lyrics = driver.find_element(xpath: xpath).text
    rescue => e
      sleep(12)
      puts e.message
      lyrics = page_url
      puts page_url

    end

    return lyrics

  end


  def create_file(title, song_lyrics)

    begin
      #https://www.delftstack.com/howto/ruby/ruby-file-exists/
      unless File.exists?("./db/all_songs/#{title}")
        FileUtils.mkdir_p("./db/all_songs/#{title}")
        #system 'mkdir', '-p', "./db/all_songs/#{title}"

        unless File.file?("./db/all_songs/#{title}/#{title}.txt")
          File.write("./db/all_songs/#{title}/#{title}.txt", "")

          #https://stackoverflow.com/questions/601888/how-do-you-loop-through-a-multiline-string-in-ruby
          song_lyrics.each_line do |line|
            File.write("./db/all_songs/#{title}/#{title}.txt", "#{line}", mode:'a')
          end
        end

      end

      #if File.exists?("./db/all_songs/#{title}") && File.file?("./db/all_songs/#{title}/#{title}.txt")

      #end


    rescue => e
      e.message
      print title + "is here \n"
      begin
        File.write("./db/all_songs/.empty/#{title.gsub("/", "-")}.txt", "")
      rescue => e
        e.message
        print "#{title} .empty string '/'"

      end

      #ign.r.r l.s d.ss.rs v.d.s
    end

  end

end