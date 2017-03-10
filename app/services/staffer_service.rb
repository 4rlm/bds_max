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
        a=50
        # z=350
        # a=200
        # z=400
        # a=400
        # z=600
        # a=600
        # z=800
        # a=800
        # z=1000
        # a=1000
        # z=1200
        # a=1200
        z=-1



        #### NEED HELP: undefined method `text' for nil:NilClass (DEALER.COM) / "METHOD ERROR"

        ### DEALER.COM:
        # indexers = Indexer.where(template: "Dealer.com").where.not(staff_url: nil).where(indexer_status: "CS Error")[a..z] ## 6,180
        # indexers = Indexer.where(clean_url: "http://www.yarktoyota.com").where.not(staff_url: nil)
        # http://www.maxmadsenmitsubishiaurora.com/dealership/staff.htm
        # http://www.southwesthyundai.com/dealership/staff.htm
        # http://www.robinsford.com/dealership/staff.htm
        # http://www.cecilhondo.com/dealership/staff.htm
        # http://www.sonicautomotive.com/dealership/staff.htm
        # http://www.grooveford.net/dealership/staff.htm
        # http://www.jimwhitehonda.com/dealership/staff.htm

        # Ford Direct (Change from Dealer.com)
        # http://www.nyeford.net/dealership/staff.htm
        # http://www.murphyfordonline.com/dealership/staff.htm
        # http://www.gbwestbend.com/dealership/staff.htm


        # indexers = Indexer.where(template: "Cobalt").where.not(staff_url: nil).where(contact_status: nil)[a..z]  ## 2,691
        # indexers = Indexer.where(template: "DealerOn").where.not(staff_url: nil).where(contact_status: nil)[a..z] ## 325
        # indexers = Indexer.where(template: "DEALER eProcess").where.not(staff_url: nil).where(contact_status: nil)[a..z]  ## 547
        # indexers = Indexer.where(template: "Dealer Inspire").where.not(staff_url: nil).where(contact_status: nil)[a..z] ## 197

        # indexers = Indexer.where(template: "Dealer Direct").where.not(staff_url: nil).where(contact_status: nil)[a..z] ## 0
        # indexers = Indexer.where(template: "Dealer.com").where.not(staff_url: nil).where(indexer_status: "Retry")[a..z] ## 13
        # indexers = Indexer.where(template: "DealerFire").where.not(staff_url: nil).where(contact_status: nil)[a..z] ## 50


        indexers = Indexer.where(staff_url: "http://www.jimwhitehonda.com/dealership/staff.htm")


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

                indexer.update_attributes(indexer_status: "CS Error", contact_status: cs_error_code)
            end ## rescue ends

            sleep(3)
        end ## .each loop ends

    end
end
