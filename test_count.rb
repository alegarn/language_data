parser = File.open("test.txt", "r")
count = {} #hash
#supprimer la ponctuation
end_text = parser.each do |line|
  # https://stackoverflow.com/questions/10073332/stripping-non-alphanumeric-chars-but-leaving-spaces-in-ruby
  words = line.downcase.gsub(/[^a-z0-9\s]/i, '').split(' ')
  # chercher dans les lignes
  words.each do |parse|
    # existe ou pas dans le hash? non, ajouter, mettre sa valeur à 1
    if !count.key(parse) == parse
      words << parse
      words.key(parse) = 1
    end
    # existe, valeur +1
    if count.key(parse) == parse
      words.key(parse) = words.key(parse) + 1
    end
  end
  puts words.values
end
