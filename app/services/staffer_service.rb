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

require 'servicers/contact_scraper' # Bridges ContactScraper Class to StafferService Class.

require 'objspace' ## Not needed.  delete later.

class StafferService
  include InternetConnectionValidator

  ###############################################
  # Call: StafferService.new.start_contact_scraper
  # Call: ContactScraper.new.cs_starter
  def start_contact_scraper
    puts ">> start_contact_scraper..."
    # ContactScraper.new.delay.cs_starter
    ContactScraper.new.cs_starter
  end
  ###############################################

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
