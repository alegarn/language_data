require 'bundler'
Bundler.require

require_relative 'lib/app/application'
require_relative 'lib/app/frequency_scrapper'
require_relative 'lib/app/title_lyrics_scrapper'
require_relative 'lib/app/test_count'
require_relative 'lib/app/select'
#Quelques étapes - PATH - Gem

Application.new
