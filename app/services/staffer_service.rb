require 'mechanize'
require 'nokogiri'
require 'open-uri'
require 'staffer_helper/cs_helper'
require 'staffer_helper/dealer_eprocess_cs'
require 'staffer_helper/dealerfire_cs'
require 'staffer_helper/dealer_inspire_cs'
require 'staffer_helper/cobalt_cs'
require 'staffer_helper/dealeron_cs'
require 'staffer_helper/dealer_direct_cs'
require 'staffer_helper/dealer_com_cs'
require 'indexer_helper/rts/rts_manager'

class StafferService
  include InternetConnectionValidator

  def cs_starter
    queried_ids = Indexer.select(:id).where.not(staff_url: nil, contact_status: "CS Result").where('scrape_date <= ?', Date.today - 1.day).sort[0..9].pluck(:id)

    nested_ids = queried_ids.in_groups(5)
    nested_ids.each { |ids| delay.nested_iterator(ids) }
  end

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
      error_msg = "CS Error: #{@html_error}"
      if error_msg.include?("404 => Net::HTTPNotFound")
        cs_error_code = "404 Error"
      elsif error_msg.include?("connection refused")
        cs_error_code = "Connection Error"
      elsif error_msg.include?("undefined method")
        cs_error_code = "Method Error"
      elsif error_msg.include?("TCP connection")
        cs_error_code = "TCP Error"
      else
        cs_error_code = "CS Error"
      end

      puts "=== #{cs_error_code}: #{url}\n\n"

      indexer.update_attributes(scrape_date: DateTime.now, indexer_status: cs_error_code, contact_status: cs_error_code)

    end ## rescue ends

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
