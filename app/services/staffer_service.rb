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

  def cs_data_getter
    a=0
    # z=200
    # a=200
    # z=250
    # a=250
    # z=375
    # a=375
    # z=400
    # a=400
    z=-1


    indexers = Indexer.where(contact_status: "TCP Error").where.not(staff_url: nil)[a..z] # 800
    # indexers = Indexer.where(contact_status: nil).where.not(staff_url: nil).where(template: "DealerFire") # #747
    # indexers = Indexer.where(contact_status: nil).where.not(staff_url: nil).where(template: "DEALER eProcess") # 547


    counter=0
    range = z-a
    indexers.each do |indexer|
      template = indexer.template
      url = indexer.staff_url

      counter+=1
      puts "\n============================\n"
      puts "[#{a}...#{z}]  (#{counter}/#{range})\nurl: #{url}\nindexer id: #{indexer.id}"

      begin
        @agent = Mechanize.new
        html = @agent.get(url)

        case template
        when "Dealer.com"
          DealerComCs.new.contact_scraper(html, url, indexer)
        when "Cobalt"
          CobaltCs.new.contact_scraper(html, url, indexer)
        when "DealerOn"
          DealeronCs.new.contact_scraper(html, url, indexer)
        when "DealerCar Search"
          # dealercar_search_cs(html, url, indexer)
        when "Dealer Direct"
          DealerDirectCs.new.contact_scraper(html, url, indexer)
        when "Dealer Inspire"
          DealerInspireCs.new.contact_scraper(html, url, indexer)
        when "DealerFire"
          DealerfireCs.new.contact_scraper(html, url, indexer)
        when "DEALER eProcess"
          DealerEprocessCs.new.contact_scraper(html, url, indexer)
        end

      rescue
        error = $!.message
        error_msg = "CS Error: #{error}"
        if error_msg.include?("connection refused")
          cs_error_code = "Connection Error"
        elsif error_msg.include?("undefined method")
          cs_error_code = "Method Error"
        elsif error_msg.include?("404 (Net::HTTPNotFound)")
          cs_error_code = "404 Error"
        elsif error_msg.include?("TCP connection")
          cs_error_code = "TCP Error"
        else
          cs_error_code = "CS Error"
        end
        indexer.update_attributes(indexer_status: cs_error_code, contact_status: cs_error_code)
      end ## rescue ends

      sleep(3)
    end ## .each loop ends

  end

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
end
