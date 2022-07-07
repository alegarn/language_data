class MainScrapper

  def initialize
    puts "url à scrapper"
    url = "https://www.azlyrics.com"
    #juste un groupe
    pages = discography_parser
    lyrics_scrapper(url, pages)
    #étape suivante
  end

  def lyrics_scrapper(url, song_links)
    titles = song_links[0]
    links = song_links[1]

    lyrics = []
    n = 0
    #parser les musiques
    while n < titles.length
      #moving ip
      if n%35 == 0 && n > 0
        # need to add the choice
        change_ip
      end

      format_datas = change_url_title(titles, url, links,n)
      title = format_datas[0]
      page_url = format_datas[1]

      song_lyrics = extract_song_lyrics(page_url)
      create_file(title, song_lyrics)

      n = n + 1
    end


  end

  def discography_parser
    # option: écrire le nom d'un groupe
    # va trouver tous les noms les plus proches (sont contenus dans url vérifié)
    url_band = "https://www.azlyrics.com/a/a1.html"
    page = Nokogiri::HTML(URI(url_band).open)
    titles = []
    links = []
    page_links = page.css('div.listalbum-item').css('a')

    return take_page_links_song_titles(page_links, links, titles)

  end

  def change_ip
    `nordvpn connect`
    sleep(30)
  end

  def change_url_title(titles, url, links,n)
    sleep(rand(1..5))
    title = titles[n].downcase.gsub(/[^a-z0-9\s]/i, '').gsub(/[ ]/, '_')
    puts title
    page_url = url + links[n]
    puts page_url

    return [title, page_url]
  end

  def extract_song_lyrics(page_url)
    page = Nokogiri::HTML(URI(page_url).open)
    xpath = "/html/body/div[2]/div/div[2]/div[5]"

    return page.xpath(xpath)

  end

  def create_file(title, song_lyrics)

    system 'mkdir', '-p', "./db/all_songs/#{title}"
    File.write("./db/all_songs/#{title}/#{title}.txt", "")

    song_lyrics.each do |node|
      line = node.text
      File.write("./db/all_songs/#{title}/#{title}.txt", "#{line}", mode:'a')
    end

  end

  def take_page_links_song_titles(page_links, links, titles)

    page_links.each do |node|
      href = node.attribute('href').value
      links << href
      titles << node.text
    end

    return [titles, links]

  end


end
