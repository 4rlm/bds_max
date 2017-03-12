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
    def cs_data_getter
        # a=0
        # z=125
        # a=125
        # z=250
        # a=250
        # z=375
        a=375
        # z=400
        # a=400
        # z=1300
        z=-1


        indexers = Indexer.where(indexer_status: "Retry")[a..z] ## 504

        # indexers = Indexer.where.not(template: "Dealer.com").where.not(template: nil).where.not(staff_url: nil).where(indexer_status: "CS Error")
        # indexers.each{|x|x.update_attribute(:indexer_status, "Retry")}

        # Ford Direct (Change from Dealer.com)
        # http://www.nyeford.net/dealership/staff.htm
        # http://www.murphyfordonline.com/dealership/staff.htm
        # http://www.gbwestbend.com/dealership/staff.htm


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
                    dealercar_search_cs(html, url, indexer)
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
                error_msg = "RT Error: #{error}"
                if error_msg.include?("connection refused")
                    cs_error_code = "Connection Error"
                elsif error_msg.include?("undefined method")
                    cs_error_code = "Method Error"
                elsif error_msg.include?("404 => Net::HTTPNotFound")
                    cs_error_code = "404 Error"
                elsif error_msg.include?("TCP connection")
                    cs_error_code = "TCP Error"
                else
                    cs_error_code = error_msg
                end
                puts "\n\n>>> #{error_msg} <<<\n\n"

                indexer.update_attribute(:indexer_status, "CS Error")
            end ## rescue ends

            sleep(3)
        end ## .each loop ends

    end
end
