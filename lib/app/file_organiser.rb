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

    unless Dir.exists?("artists")
      Dir.mkdir("artists")
    end
    Dir.chdir("artists")


    0.upto(n) do |i|

      `nordvpn connect`

      paus()

      band = g_band_name(url_band, i)

      if Dir.exists?("#{band}")
        url_band = url_band[1, (url_band.length - 1)]
        band = g_band_name(url_band, i)

      end

      if Dir.exists?("#{band}.csv")
        url_band = url_band[1, (url_band.length - 1)]
        band = g_band_name(url_band, i)
      end


      uri_str = url_band[i]
      unless Dir.exists?("#{band}")

        Dir.mkdir("#{band}")
        #https://linuxtut.com/i-want-to-download-a-file-on-the-internet-using-ruby-and-save-it-locally-(with-caution)-74737/
        URI.open(uri_str) do |res|
          IO.copy_stream(res, "#{band}.html")
        end

      end

      Dir.chdir("#{band}")


      #driver = browser()
      #wait = Selenium::WebDriver::Wait.new(:timeout => 10)

      page = Nokogiri::HTML(URI.open((uri_str)))




      #page = driver.get(url_band[c])

      album = "a"
      links = []
      title = " "

      i_albums = 1
      i_titles = 1
      c = 1

      while true

        path_album = "/html/body/div[2]/div/div[2]/div[4]/div[#{i_albums.to_s}]/b"

        album = find_album(page, path_album).gsub(/\s+/, " ").strip.gsub(" ", "_").gsub('"', '')

        puts "#{album}  ... #{i_albums}"
        i_titles = i_titles + 1
        i_albums = i_albums + 1

        unless album == ""
          unless Dir.exists?("#{album}")
            Dir.mkdir("#{album}")
            puts Dir.getwd

          end
          Dir.chdir("#{album}")

        end

        title = "a"

        while title != ""

          unless title == ""
            title = title.gsub("/", "-").gsub(/\s+/, " ").strip.gsub(" ", "_")
            unless Dir.exist?("#{title}")
              Dir.mkdir("#{title}")
              puts Dir.getwd
            end
          end


          path_title = "/html/body/div[2]/div/div[2]/div[4]/div[#{i_titles.to_s}]/a"
          title = find_title(page, path_title)
          unless title == ""
            albums_titles_band << [album, title, band]
          end
          i_titles = i_titles + 1
          i_albums = i_albums + 1
        end


        Dir.chdir("../")

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
          Dir.chdir("#{band}")
        end

      end

      print("albums over")
      puts albums_titles_band

      unless Dir.exists?("#{band}.csv")
        CSV.open("#{band}.csv", "w") do |csv|
          albums_titles_band.each { |line|
            album = "#{line[0]}"
            title = "#{line[1]}"
            band = "#{line[2]}"
            csv << [album, title, band]
          }
        end
        albums_titles_band = []
      end

    end

  end

  def g_band_name(url_band, i)

    band = url_band[i].delete_prefix("https://www.azlyrics.com/").chomp(".html")
    x = band.length
    band = band[2, x]
    band = band.gsub(/\s+/, " ").strip.gsub(" ", "_")

    return band

  end


  def paus()

    count = rand(5..17)
    puts count
    sleep(count)

  end

  def find_album(page, path_album)

    album = ""
    page.xpath(path_album).each { |node|
      album = node.text
    }

    return album

  end

  def find_title(page, path_title)

    title = ""
    page.xpath(path_title).each { |node|
      title = node.text
    }

    return title.gsub("/", "-").gsub(/\s+/, " ").strip.gsub(" ", "_")

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
