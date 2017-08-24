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

# Call: IndexerService.new.start_page_finder
# Call: PageFinderA.new.pf_starter

class PageFinderA
  include InternetConnectionValidator
  include ComplexQueryIterator

  def initialize
    puts "\n\n== Welcome to the PageFinderA Class! ==\n\n"
    @query_limit = 10 #=> Number of rows per batch in raw_query.

    ## Below are Settings for ComplexQueryIterator Module.
    @dj_wait_time = 3 #=> How often to check dj queue count.
    @dj_count_limit = 0 #=> Num allowed before releasing next batch.
    @number_of_groups = 2 #=> Divide query into groups of x.
  end

  def pf_starter
    generate_query
  end

  def generate_query
    # Indexer.where("redirect_status LIKE '%Error%'").where(archive: false)

    raw_query = Indexer
    .select(:id)
    .where.not("redirect_status LIKE '%Error%'")
    .where(archive: false)
    # .where.not(clean_url: nil)
    # .where.not(template: nil)
    # .where("template NOT LIKE '%Error%'")
    # .where(page_finder_date: nil)

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
    # puts "page_finder_date: #{indexer.page_finder_date}"
    puts "#{"="*30}\n\n"
  end

  ##########################


  def template_starter(id)
    indexer = Indexer.find(id)
    # view_indexer_current_db_info(indexer)

    #### !!!! RAW URL BEING USED FOR TESTING ONLY. ###
    # url = indexer.clean_url #=> !CHANGE BACK TO THIS, AFTER TESTING!!
    url = indexer.raw_url #=> !FOR TESTING ONLY!!
    puts "\n\nURL: #{url}"
    start_mechanize(url) #=> returns @html

    if @html
      page = @html
      puts page
      # page_finder(page, "staff")
      # page_finder(page, "location")
    else
      puts "\n\n== Page Finder Error!! ==\n\n"
      puts @error_code
      # indexer.update_attributes(indexer_status: "PageFinderA", loc_status: @error_code, stf_status: @error_code, page_finder_date: DateTime.now)
    end

    # puts "Sleep(2)..."
    # sleep(2)
  end

end
