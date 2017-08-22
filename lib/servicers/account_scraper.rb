require 'open-uri'
require 'mechanize'
require 'uri'
require 'nokogiri'
require 'socket'
require 'httparty'
require 'delayed_job'
require 'indexer_helper/rts/dealerfire_rts'
require 'indexer_helper/rts/cobalt_rts'
require 'indexer_helper/rts/dealer_inspire_rts'
require 'indexer_helper/rts/dealeron_rts'
require 'indexer_helper/rts/dealer_com_rts'
require 'indexer_helper/rts/dealer_direct_rts'
require 'indexer_helper/rts/dealer_eprocess_rts'
require 'indexer_helper/rts/dealercar_search_rts'
require 'indexer_helper/page_finder'  # Indexer Page Finder
require 'indexer_helper/rts/rts_helper'
require 'indexer_helper/rts/rts_manager'
require 'indexer_helper/unknown_template' # Unknown template's info scraper
require 'indexer_helper/helper' # All helper methods for indexer_service
require 'servicers/verify_url' # Bridges UrlRedirector Module to indexer/services.
require 'curb' #=> for url_redirector

# Call: IndexerService.new.start_account_scraper
# Call: AccountScraper.new.as_starter

class AccountScraper
  include InternetConnectionValidator
  include ComplexQueryIterator

  def initialize
    puts "\n\n== Welcome to the AccountScraper Class! ==\n\n"
    @query_limit = 10 #=> Number of rows per batch in raw_query.

    ## Below are Settings for ComplexQueryIterator Module.
    @dj_wait_time = 3 #=> How often to check dj queue count.
    @dj_count_limit = 0 #=> Num allowed before releasing next batch.
    @number_of_groups = 2 #=> Divide query into groups of x.
  end

  def as_starter
    generate_query
  end

  def generate_query
    # raw_query = Indexer.select(:id).where(archive: false).where.not(clean_url: nil).where.not(template: nil).where.not(template: "Unidentified").where("template NOT LIKE '%Error%'").where(account_scrape_date: nil)

    raw_query = Indexer
    .select(:id)
    .where(archive: false)
    .where.not(clean_url: nil)
    .where.not(template: nil)
    .where.not(template: "Unidentified")
    .where("template NOT LIKE '%Error%'")
    .where(account_scrape_date: nil)

    iterate_raw_query(raw_query) #=> Method is in ComplexQueryIterator.
  end

  #############################################
  ## ComplexQueryIterator takes raw_query and creates series of forked iterations based on limits established above in initialize method.  Then it calls 'template_starter(id)' method.  Module serves as bridge for iteration work.
  #############################################

  def view_indexer_current_db_info(indexer)
    puts "\n=== Current DB Info ===\n"
    puts "indexer_status: #{indexer.indexer_status}"
    puts "template: #{indexer.template}"
    puts "clean_url: #{indexer.clean_url}"
    puts "account_scrape_date: #{indexer.account_scrape_date}"
    puts "#{"="*30}\n\n"
  end

  def template_starter(id)
    indexer = Indexer.find(id)
    view_indexer_current_db_info(indexer)

    url = indexer.clean_url
    start_mechanize(url) #=> returns @html
    html = @html

    begin
      template = indexer.template
      # template == "Cobalt" ? url = "#{clean_url}/HoursAndDirections" : url = clean_url
      method = IndexerTerm.where(response_term: template).where.not(mth_name: nil).first
      term = method.mth_name

      case term
      when "dealer_com_rts"
        DealerComRts.new.rooftop_scraper(html, url, indexer)
      when "cobalt_rts"
        CobaltRts.new.rooftop_scraper(html, url, indexer)
      when "dealeron_rts"
        DealeronRts.new.rooftop_scraper(html, url, indexer)
      when "dealercar_search_rts"
        DealercarSearchRts.new.rooftop_scraper(html, url, indexer)
      when "dealer_direct_rts"
        DealerDirectRts.new.rooftop_scraper(html, url, indexer)
      when "dealer_inspire_rts"
        DealerInspireRts.new.rooftop_scraper(html, url, indexer)
      when "dealerfire_rts"
        DealerfireRts.new.rooftop_scraper(html, url, indexer)
      when "dealer_eprocess_rts"
        DealerEprocessRts.new.rooftop_scraper(html, url, indexer)
      end

    rescue
      puts "\n\n== Account Scraper Error!! ==\n\n"
      puts @error_code

      # indexer.update_attributes(indexer_status: "AccountScraper", rt_sts: @error_code, account_scrape_date: DateTime.now)

    end ## rescue ends
  end

end
