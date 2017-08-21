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

  def initialize
    puts "\n\n== Welcome to the ContactScraper Class! ==\n\n"
    @dj_wait_time = 5
    @dj_count_limit = 0
    @query_limit = 20
    @number_of_groups = 2
  end

  def cs_starter
    generate_query
  end

  def generate_query
    # .where.not(staff_url: nil, contact_status: "CS Result")

    raw_query = Indexer
    .select(:id)
    .where("template NOT LIKE '%Error%'")
    .where(contact_status: "CS Result")
    .where('scrape_date <= ?', Date.today - 1.day)

    iterate_raw_query(raw_query)
  end


  #### MOVE BELOW TO MODULE ####


  def get_dj_count
    Delayed::Job.all.count
  end

  def pause_iteration
    until get_dj_count <= @dj_count_limit
      puts "\nWaiting on #{get_dj_count} Queued Jobs | Queue Limit: #{@dj_count_limit}"
      puts "Please wait #{@dj_wait_time} seconds ...\n\n"
      sleep(@dj_wait_time)
    end
  end

  def iterate_raw_query(raw_query)
    raw_query.find_in_batches(batch_size: @query_limit) do |batch_of_ids|
      pause_iteration
      format_query_results(batch_of_ids)
    end
  end

  def format_query_results(batch_of_ids)
    puts "\n=== FORMATTING NEXT BATCH OF IDs ===\n\n"
    batch_of_ids = (batch_of_ids.map!{|object| object.id}).in_groups(@number_of_groups) #=> Converts objects into ids, then slices into nested arrays.
    puts "batch_of_ids: #{batch_of_ids}"
    batch_of_ids.each { |ids| delay.standard_iterator(ids) }
    # batch_of_ids.each { |ids| standard_iterator(ids) }
  end

  def standard_iterator(ids)
    puts "ids: #{ids}"
    ids.each { |id| delay.template_starter(id) }
    # ids.each { |id| template_starter(id) }
  end


  #### MOVE ABOVE TO MODULE ####


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
