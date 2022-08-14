#require 'open-uri'
#require 'fileutils'

#require 'webdrivers'
#require 'selenium-webdriver'

class MultiLyricScraper

  def initialize

    0.upto(5) do |c|
      #
      driver = browser()
      wait = Selenium::WebDriver::Wait.new(:timeout => 10)

      pages = discography_parser(c, driver, wait)
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

    options = Selenium::WebDriver::Options.firefox #ch..se f.r.f.x
    #options = Selenium::WebDriver::Firefox::Options.new(args: ['-headless']) #br.ws.r h..dl.ss m.de

    driver = Selenium::WebDriver.for(:firefox, options: options)

    return driver
  end


  def discography_parser(c, driver, wait)
    # option: écrire le nom d'un groupe
    # va trouver tous les noms les plus proches (sont contenus dans url vérifié)
    #"https://www.azlyrics.com/a/a1.html"
    url_band = [
      "https://www.azlyrics.com/e/eminem.html",
      "https://www.azlyrics.com/b/beatles.html",
      "https://www.azlyrics.com/j/jackson.html",
      "https://www.azlyrics.com/m/madonna.html",
      "https://www.azlyrics.com/b/bobmarley.html",
      "https://www.azlyrics.com/r/rihanna.html"
    ]
    page = driver.get(url_band[c])
    titles = []
    links = []

    begin
      #pr.ndre l.s l..ns
      elements = driver.find_elements(:class,'listalbum-item')
      wait.until{elements}
    rescue => e
      puts e.message
      puts url_band
    end

    elements.each { |e|

      #en m.th.d.s
      begin
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
        titles << title
      rescue => error
        puts error.message
        puts "title"
        title = "no_title"
        puts url_band
          titles << title
      end

    }


    return [titles, links, url_band[c]]

  end


  def lyrics_scrapper(driver, song_links, tab_url)
    titles = song_links[0]
    links = song_links[1]

    lyrics = []
    n = 0
    #parser les musiques
    while n < titles.length
      #moving ip
      if n%30 == 0 && n > 0

        # need to add the choice
        driver = change_ip(driver, tab_url)

      end

      title = titles[n]
      page_url = links[n]

      song_lyrics = extract_song_lyrics(page_url, driver)
      create_file(title, song_lyrics)

      n = n + 1
    end


  end



  def change_ip(driver, tab_url)
    driver.quit
    `nordvpn connect`
    sleep(30)
    driver = browser()
    driver.get(tab_url)
    return driver
  end


  def extract_song_lyrics(page_url, driver)

    begin
      driver.get(page_url)
      xpath = "/html/body/div[2]/div/div[2]/div[5]"
      lyrics = driver.find_element(xpath: xpath).text
    rescue => e
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
      end

      unless File.file?("./db/all_songs/#{title}/#{title}.txt")
        File.write("./db/all_songs/#{title}/#{title}.txt", "")

        #https://stackoverflow.com/questions/601888/how-do-you-loop-through-a-multiline-string-in-ruby
        song_lyrics.each_line do |line|
          File.write("./db/all_songs/#{title}/#{title}.txt", "#{line}", mode:'a')
        end
      end

    rescue => e
      print title + "is here"
    end




  end

end
