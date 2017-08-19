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

class StafferService
  include InternetConnectionValidator

  def cs_starter
    # Call: StafferService.new.cs_starter
    # begin
    # queried_ids = Indexer.select(:id).where("template NOT LIKE '%Error%'").where.not(staff_url: nil, contact_status: "CS Result").where('scrape_date <= ?', Date.today - 1.day).sort[0...200].pluck(:id)

    # start = 0
    # batch_size = 10
    # Indexer.select(:id).where("template NOT LIKE '%Error%'").where.not(staff_url: nil, contact_status: "CS Result").where('scrape_date <= ?', Date.today - 1.day).find_in_batches(start: start, batch_size: batch_size) do |group|
    #
    #   counter = 0
    #   next if counter == batch_size
    #   group.each do |row|
    #     counter += 1
    #     puts "counter: #{counter} | batch_size: #{batch_size}"
    #     id_tester(row.id)
    #   end
    # end

    batch_size = 10
    continue = false
    Indexer.select(:id).where("template NOT LIKE '%Error%'").where.not(staff_url: nil, contact_status: "CS Result").where('scrape_date <= ?', Date.today - 1.day).find_in_batches(start: 0, batch_size: batch_size) do |grouped_ids|

      grouped_ids.map!{|obj| obj.id}
      @last_id = grouped_ids.last
      puts grouped_ids.inspect
      puts "@last_id: #{@last_id}"
      nested_ids = grouped_ids.in_groups(2)

      nested_ids.each { |ids| standard_iterator(ids) }
      next if continue == true

    end

  end


  def standard_iterator(ids)
    ids.each { |id| sampler(id) }
    # ids.each { |id| delay.template_starter(id) }
    # ids.each { |id| template_starter(id) }
  end

  def sampler(id)
    puts "ID: #{id}"
    if id == @last_id
      puts "ID: #{id} | @last_id = #{@last_id}"
      continue = true
    else
      continue = false
    end

  end



  # @last_id = queried_ids.last
  # nested_ids = queried_ids.in_groups(2)

  # nested_ids.each { |ids| delay.nested_iterator(ids) }
  # nested_ids.each { |ids| nested_iterator(ids) }
  # rescue
  # puts "\n\n==== Empty Query ====\n\n"
  # end

  def nested_iterator(ids)
    ids.each { |id| delay.template_starter(id) }
    # ids.each { |id| template_starter(id) }
  end

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
      indexer.update_attributes(indexer_status: "ContactScraper", contact_status: @error_code, scrape_date: DateTime.now)
      # new_query(id)
    end ## rescue ends

    new_query(id)
  end

  def new_query(id)
    if id == @last_id
      puts "\n\n===== Last ID: #{id}=====\n===== @last_id: #{@last_id}=====\n\n"
      delay.cs_starter
    end
  end


  ################################################################

  # When first name is "["Jack", "McCarthy", "Business Manage.....", it cleans to "Jack".
  def fname_cleaner
    urls = Indexer.where(template: "Dealer.com").map(&:clean_url).uniq
    staffers = Staffer.where(domain: urls)

    staffers.each do |staffer|
      fname = staffer.fname
      lname = staffer.lname
      fullname = staffer.fullname

      if fname && lname && fullname
        merged_name = fname + " " + lname

        if fullname != merged_name
          puts "\n\nOLD First Name: #{fname}\nNEW First Name: #{fullname.split(" ")[0]}\n\n"
          staffer.update_attributes(fname: fullname.split(" ")[0])
        end
      end
    end
  end

  def crm_staff_counter
    cores = Core.all

    num = 0
    cores.each do |core|
      num += 1
      staff_count = Staffer.where(sfdc_id: core.sfdc_id).count
      puts ">>>>>>num:  #{num}, staff_count: #{staff_count}"
      core.update_attribute(:crm_staff_count, staff_count)
    end
  end


end
