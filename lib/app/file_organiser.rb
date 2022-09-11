class FileOrganiser

  def initialize
    # option: écrire le nom d'un groupe
    # va trouver tous les noms les plus proches (sont contenus dans url vérifié)

    #{}"https://www.azlyrics.com/b/bobmarley.html",
    #{}"https://www.azlyrics.com/r/rihanna.html"

    url_band = [
      "https://www.azlyrics.com/a/a1.html",
      "https://www.azlyrics.com/e/eminem.html",
      "https://www.azlyrics.com/b/beatles.html",
      "https://www.azlyrics.com/j/jackson.html",
      "https://www.azlyrics.com/m/madonna.html"
    ]

    n = (url_band.length) - 1

    albums_titles_band = []

    create_artists_enter_dir()


    0.upto(n) do |i|

      `nordvpn connect`

      paus()

      urlband_band_name_str = create_directory_change_url_get_page_band(url_band, i)
      band = urlband_band_name_str[1]
      #driver = browser()
      #wait = Selenium::WebDriver::Wait.new(:timeout => 10)

      #  page = Nokogiri::HTML(URI.open((urlband_band_name_str[2])))

      page = Nokogiri::HTML(URI.open(("../#{urlband_band_name_str[1]}.html")))

      #page = driver.get(url_band[c])

      album = "a"
      links = []
      title = " "

      counter_for_albums = 1
      counter_for_titles = 1
      c = 1

      while true

        album_and_page = load_album_go_dir(counter_for_albums, page)

        #  if c == 1
        #  plus_counters_alb_titles
        #  end
        counter_for_titles = counter_for_titles + 1
        counter_for_albums = counter_for_albums + 1

        title = "a"

        while title != ""

          title = find_title(album_and_page[1], title, counter_for_titles)
          albums_titles_band = append_array(album, title, band, albums_titles_band)
          counter_for_titles = counter_for_titles + 1
          counter_for_albums = counter_for_albums + 1
        end


        Dir.chdir("../")

        counter_for_titles = counter_for_titles - 1
        counter_for_albums = counter_for_albums - 1

        c = modify_counter_go_band_dir(title, album_and_page[0], album_and_page[1], c )

        if c.class == Array
          break
        end

      end

      print("albums over")
      puts albums_titles_band

      unless Dir.exists?("#{band}.csv")
        creat_csv_file(band, albums_titles_band)
        albums_titles_band = []
      end

    end

  end

  def create_artists_enter_dir()
    unless Dir.exists?("artists")
      Dir.mkdir("artists")
    end
    Dir.chdir("artists")
  end

  def create_directory_change_url_get_page_band(url_band, i)
    band = g_band_name(url_band, i)

    new_url_band = detect_the_band_directory_then_skip?(band, url_band, i)
    url_band = new_url_band[0]
    band = new_url_band[1]

    url_band_str = url_band[i]

    download_total_discography_page(band, url_band_str )

    Dir.chdir("#{band}")

    return [url_band, band, url_band_str]
  end

  def g_band_name(url_band, i)
    unless url_band[i].nil?
      band = url_band[i].delete_prefix("https://www.azlyrics.com/").chomp(".html")
      x = band.length
      band = band[2, x]
      band = band.gsub(/\s+/, " ").strip.gsub(" ", "_")

      return band
    end
  end

  def detect_the_band_directory_then_skip?(band, url_band, i)

    if Dir.exists?("#{band}")
      url_band = url_band[1, (url_band.length - 1)]
      band = g_band_name(url_band, i)
    end

    new_url_band = detect_the_band_csv_then_skip?(band, url_band, i)
    return new_url_band
  end

  def detect_the_band_csv_then_skip?(band, url_band, i)
    if Dir.exists?("#{band}.csv")
      url_band = url_band[1, (url_band.length - 1)]
      band = g_band_name(url_band, i)
      return [url_band, band]
    end
    return [url_band, band]
  end

  def download_total_discography_page(band, uri_str)
    unless Dir.exists?("#{band}")

      Dir.mkdir("#{band}")
      #https://linuxtut.com/i-want-to-download-a-file-on-the-internet-using-ruby-and-save-it-locally-(with-caution)-74737/
      URI.open(uri_str) do |res|
        IO.copy_stream(res, "#{band}.html")
      end

    end

  end

  def plus_counters_alb_titles(counter_for_titles, counter_for_albums)
    counter_for_titles = counter_for_titles + 1
    counter_for_albums = counter_for_albums + 1
    return [counter_for_albums, counter_for_titles]
  end


  def paus()

    count = rand(5..17)
    puts count
    sleep(count)

  end

  def load_album_go_dir(counter_for_albums, page)
    path_album = "/html/body/div[2]/div/div[2]/div[4]/div[#{counter_for_albums.to_s}]/b"

    album = find_album(page, path_album).gsub(/\s+/, " ").strip.gsub(" ", "_").gsub('"', '')

    puts "#{album}  ... #{counter_for_albums}"

    verify_create_enter_in_alb_dir(album)
    return [album, page]
  end


  def find_album(page, path_album)

    album = ""
    page.xpath(path_album).each { |node|
      album = node.text
    }

    return album

  end

  def verify_create_enter_in_alb_dir(album)
    unless album == ""
      unless Dir.exists?("#{album}")
        Dir.mkdir("#{album}")
        puts Dir.getwd

      end
      Dir.chdir("#{album}")

    end

  end

  def find_title(page, title, counter_for_titles)
    title = modify_create_title_dir(title)

    path_title = "/html/body/div[2]/div/div[2]/div[4]/div[#{counter_for_titles.to_s}]/a"

    page.xpath(path_title).each { |node|
      title = node.text
    }

    return title.gsub("/", "-").gsub(/\s+/, " ").strip.gsub(" ", "_")

  end


  def modify_create_title_dir(title)
    unless title == ""
      title = title.gsub("/", "-").gsub(/\s+/, " ").strip.gsub(" ", "_")
      unless Dir.exist?("#{title}")
        Dir.mkdir("#{title}")
        puts Dir.getwd
      end
      return title
    end
    return title
  end


  def append_array(album, title, band, albums_titles_band)
    unless title == ""
      return albums_titles_band << [album, title, band]
    end
    return albums_titles_band
  end


  def modify_counter_go_band_dir(title, album, page, c )
    if title == "" && album == ""
      div = ""
      page.xpath("//*[@id='azlyrics_incontent_#{c}']").each { |e|
        div = e.to_s
      }
      if div == ""
        return [c]
      end
      c = c + 1
      Dir.chdir("#{band}")
      return c
    end
    return c
  end

  def creat_csv_file(band, albums_titles_band)
    CSV.open("#{band}.csv", "w") do |csv|
      albums_titles_band.each { |line|
        album = "#{line[0]}"
        title = "#{line[1]}"
        band = "#{line[2]}"
        csv << [album, title, band]
      }
    end

  end
end
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
