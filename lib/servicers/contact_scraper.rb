require 'mechanize'
require 'nokogiri'
require 'open-uri'
require 'delayed_job'
require 'staffer_helper/cs_helper'
require 'staffer_helper/cobalt_cs'
require 'staffer_helper/dealer_com_cs'
require 'staffer_helper/dealer_direct_cs'
require 'staffer_helper/dealer_eprocess_cs'
require 'staffer_helper/dealer_inspire_cs'
require 'staffer_helper/dealerfire_cs'
require 'staffer_helper/dealeron_cs'
require 'staffer_helper/standard_scraper'
require 'indexer_helper/rts/rts_manager'

# Bridges ContactScraper Class to StafferService Class.
require 'delayed_job'

# Call: StafferService.new.start_contact_scraper
# Call: ContactScraper.new.cs_starter

class ContactScraper
  include InternetConnectionValidator
  include ComplexQueryIterator

  def initialize
    puts "\n\n== Welcome to the ContactScraper Class! ==\n\n"
    @class_pid = Process.pid
    @query_limit = 20 #=> Number of rows per batch in raw_query.

    ## Below are Settings for ComplexQueryIterator Module.
    @dj_wait_time = 3 #=> How often to check dj queue count.
    @dj_count_limit = 0 #=> Num allowed before releasing next batch.
    @number_of_groups = 2 #=> Divide query into groups of x.
  end

  def cs_starter
    generate_query
  end

  def generate_query
    # .where.not(staff_url: nil, contact_status: "CS Result")
    raw_query = Indexer
    .select(:id)
    .where(archive: false)
    .where.not(staff_url: nil)
    .where.not(template: nil)
    .where("template NOT LIKE '%Error%'")
    .where('scrape_date <= ?', Date.today - 1.day)
    .where(contact_status: "CS Result")

    iterate_raw_query(raw_query) #=> Method is in ComplexQueryIterator.
  end

  #############################################
  ## ComplexQueryIterator takes raw_query and creates series of forked iterations based on limits established above in initialize method.  Then it calls 'template_starter(id)' method.  Module serves as bridge for iteration work.
  #############################################

  def view_indexer_current_db_info(indexer)
    puts "\n=== Current DB Info ===\n"
    puts "indexer_status: #{indexer.indexer_status}"
    puts "template: #{indexer.template}"
    puts "staff_url: #{indexer.staff_url}"
    puts "web_staff_count: #{indexer.web_staff_count}"
    puts "scrape_date: #{indexer.scrape_date}"
    puts "#{"="*30}\n\n"
  end

  def template_starter(id)
    indexer = Indexer.find(id)
    view_indexer_current_db_info(indexer)
    url = indexer.staff_url
    start_mechanize(url) #=> returns @html
    html = @html

    begin
      template = indexer.template
      case template
      when "Dealer.com"
        DealerComCs.new.contact_scraper(html, url, indexer)
      when "Cobalt"
        CobaltCs.new.contact_scraper(html, url, indexer)
      when "DealerOn"
        DealeronCs.new.contact_scraper(html, url, indexer)
      when "Dealer Direct"
        DealerDirectCs.new.contact_scraper(html, url, indexer)
      when "Dealer Inspire"
        DealerInspireCs.new.contact_scraper(html, url, indexer)
      when "DealerFire"
        DealerfireCs.new.contact_scraper(html, url, indexer)
      when "DEALER eProcess"
        DealerEprocessCs.new.contact_scraper(html, url, indexer)
      else
        StandardScraperCs.new.contact_scraper(html, url, indexer)
      end
    rescue
      puts "\n\n== CS Error!! ==\n\n"
      puts @error_code
      # indexer.update_attributes(indexer_status: "ContactScraper", contact_status: @error_code, scrape_date: DateTime.now)
    end ## rescue ends
  end

end
