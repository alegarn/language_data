# language_data

### Stack


### Parts
- Data from songs (**lyrics**, Language, Song type)
  - Where? (https://www.azlyrics.com/,
  - 1 - 1 song by searching (https://www.azlyrics.com/lyrics/josgonzlez/stepout.html / )
  - 2 - 2 songs by scrapping (create priorities with 2 songs)
  - 3 - 2 languages
- Word frequency (Python? Possible with Ruby)
  - For a song (simple frequency sort
- List: each word we want to learn
  - In the song

- Data: take the frequency dictionnary
  - Where? ([wikipedia](https://en.wiktionary.org/wiki/Wiktionary:Frequency_lists)
  - 100 words first (Nokogiri scrapping (in Python Jupyter → bs4, final csv,!)
  - language: english
  - More with https://developer.musixmatch.com/ / https://lyricsovh.docs.apiary.io/)
- App Web (UI / Database)
  - With PostGreSQL (but after every csv first tsts)
  - Rails

- Best score?
 - if the words were chosen
	- take the song with best “most times of this word” said in the song
	- more than 1 word?
 - by frequency
	- song with the most basics words (if the word is high rank, top 100 = 1 point, top 200 = 2…, the song best score is 0 (points reduced = super high frequency)
 - each song has a top “repeated words” (when having 5 times at least in the song)


# the steps
- text parser (1 song) in csv
- dictionary (([wikipedia](https://en.wiktionary.org/wiki/Wiktionary:Frequency_lists)), 100 words first (some data scrapping)
- find repeating words in a song
- **the song score: a number of times the word searched are repeated in the song
