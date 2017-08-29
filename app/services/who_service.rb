require 'rubygems'
require 'whois'
require 'csv'
require 'mechanize'
require 'open-uri'
require 'nokogiri'
require 'uri'
require 'socket'
require 'indexer_helper/rts/rts_manager'
require 'servicers/whois_scraper'

###############################################
# Call: WhoService.new.start_whois_scraper
# Call: WhoisScraper.new.wi_starter
def start_whois_scraper
  puts ">> start_whois_scraper..."
  # WhoisScraper.new.delay.wi_starter
  WhoisScraper.new.wi_starter
end
