class PersonalVocabulary

  def initialize
    personal_word = ["WORD"]
    personal_rank = ["RANK"]
    personal_table = [personal_rank, personal_word]
    own_voc = choose_your_word()
    table = make_table(own_voc, personal_table)
    create_csv(table, table[1])
  end

  def choose_your_word()

    personal_voc = 0
    list = []

    while personal_voc != "esc"

      print "Write the word you want to learn:
The words will be ranked, it will depend on their writing order.
'esc' to finish
      >"
      # par liste? (des , pour les espacer)

      personal_voc = gets.chomp

      if personal_voc == "esc"
        break
      end

      list << personal_voc.downcase

    end

    print "That's your words: #{list}"
    return list

  end

  def make_table(list, table)

    p = 0

    list.each do |chosen|
      table[0] << p
      table[1] << chosen
      p = p + 1
    end

    return table
  end

  def create_csv(table, word)
    columns = table.transpose
    lines = word.length
    l = 0

    CSV.open("./db/words/words.csv", "w") do |row|
      while l < lines
        row << [table[0][l], table[1][l]]
        l = l + 1
      end
    end
    print table

  end

end
