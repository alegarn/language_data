# language_data


### Why?

When you want to learn a new language listening to popular songs seems to works fine for some. New words, go to your memory, repeated many times during your listening. People that really like the songs enjoy the process, so are more likely to repeat it, and having the words easier in memory when you compare to cramming.

Choosing the right song is not always simple (you can like it or not, the vocabulary is not adapted). With this program you can (almost yet, that is the first version) choose some songs based on the vocabulary you want (this version contains: top 100/5000 frequent english words).


### Version

- Pre-alpha (anti)features:
	- it scraps (gem: Selenium) lyrics from 5 bands only
	- it’s console only
	- you need to have Nordvpn (you can change the code if you want)
	- still some comments in the code
	- no database (just text/csv files)
	- there is no C Ruby gem
	- It’s really first stage <3

### Requirement

- Ruby: https://www.ruby-lang.org/en/documentation/installation/

- Bundler:

```
gem install bundler
```

### How to install

Run `bundle install` (choose your favorite terminal to do so) in the project’s root document.


### How it Works

Run `ruby app.rb` (Internet connection required to scrap)
