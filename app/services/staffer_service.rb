require 'mechanize'
require 'nokogiri'
require 'open-uri'
# require_relative 'staffer_service_helper'
require 'staffer_helper/cs_helper'
require 'staffer_helper/dealer_eprocess_cs'
require 'staffer_helper/dealerfire_cs'
require 'staffer_helper/dealer_inspire_cs'
require 'staffer_helper/cobalt_cs'
require 'staffer_helper/dealeron_cs'
require 'staffer_helper/dealer_direct_cs'
require 'staffer_helper/dealer_com_cs'

class StafferService
    def cs_data_getter
        a=30
        z=35

        ###### GENERAL
        # indexers = Indexer.where(template: "DealerCar Search")[a...z]
        # indexers = Indexer.where(template: "Dealer Direct")[a...z]
        # indexers = Indexer.where(template: "DealerOn")[a...z]  ##852
        # indexers = Indexer.where(template: "Dealer Inspire")[a...z]
        # indexers = Indexer.where(template: "DealerFire")[a...z]
        # indexers = Indexer.where(template: "DEALER eProcess")[a...z]


        ###### DealerCar Search STAFF PAGE
        # indexers = Indexer.where(template: "DealerCar Search")[a...z]
        # indexers = Indexer.where(clean_url: "here")


        ###### DealerFire STAFF PAGE
        # indexers = Indexer.where(template: "DealerFire")[a...z]
        # indexers = Indexer.where(clean_url: "http://www.donjacobsvolkswagen.com")
        # indexers = Indexer.where(clean_url: "http://www.weslacoford.com")
        # indexers = Indexer.where(clean_url: "http://www.palmen.com")
        # indexers = Indexer.where(clean_url: "http://www.cochranvwnorth.com")
        # indexers = Indexer.where(clean_url: "http://www.perrymotorshonda.com")
        # indexers = Indexer.where(clean_url: "http://www.jcbillionnissan.com")

        # http://www.donjacobsvolkswagen.com/team-don-jacobs-volkswagen-in-lexington-ky
        # http://www.weslacoford.com/team-payne-weslaco-ford-in-weslaco-tx
        # http://www.palmen.com/team-palmen-in-racine-kenosha-wi
        # http://www.cochranvwnorth.com/team-volkswagen-north-hills-in-wexford-pa
        # http://www.perrymotorshonda.com/team-perry-honda-in-bishop-ca
        # http://www.jcbillionnissan.com/team-jc-billion-nissan-in-bozeman-mt
        #OUR TEAM


        ###### Cobalt STAFF PAGE
        ### (HELP!!) ### DIFFERENT CSS CLASS NAMES for Email / Phone.
        ### MULTIPLE URL EXTENSIONS FOR STAFF PAGE.
        # indexers = Indexer.where(template: "Cobalt")[a...z] #3792
        # indexers = Indexer.where(clean_url: "http://www.shireycadillacgm.com")  ## /MeetOurDepartments
        # indexers = Indexer.where(clean_url: "http://www.nissanmarin.com")  ## /MeetOurDepartments
        # indexers = Indexer.where(clean_url: "http://www.irwinautoco.com")  ## /MeetOurDepartments
        # indexers = Indexer.where(clean_url: "http://www.jcharriscadillac.com")  ## /MeetOurDepartments
        # indexers = Indexer.where(clean_url: "http://www.chasechevroletstockton.com")  ## /MeetOurDepartments

        # http://www.lexusgwinnett.com/Meet-Our-Staff
        # http://www.vivachevy.com/MeetOurStaff
        # /MeetOurDepartments
        # /MeetOurStaff
        # /Meet-Our-Staff
        # /Staff

        # MEET OUR TEAM
        # MEET OUR STAFF
        # MEET THE STAFF


        ###### DEALER eProcess STAFF PAGE
        ### (HELP!!) ### DIFFERENT CSS CLASS NAMES.
        indexers = Indexer.where(template: "DEALER eProcess")[a...z]
        # indexers = Indexer.where(clean_url: "http://www.mazdaofclearlake.com")
        # indexers = Indexer.where(clean_url: "http://www.karitoyota.com") # not working
        # indexers = Indexer.where(clean_url: "http://www.usedcarnh.net") # not working
        # indexers = Indexer.where(clean_url: "http://www.rrmcsterling.com")
        # indexers = Indexer.where(clean_url: "http://www.alohakiaairport.com") # dups
        # indexers = Indexer.where(clean_url: "http://www.joecooperfordtulsa.com") # not working
        # indexers = Indexer.where(clean_url: "http://www.valenciaacura.com") # not working
        # indexers = Indexer.where(clean_url: "http://www.lumsautocenter.com")
        # indexers = Indexer.where(clean_url: "http://www.harrisisuzu.com")

        # indexers = Indexer.where(clean_url: %w(http://www.karitoyota.com http://www.usedcarnh.net http://www.rrmcsterling.com http://www.alohakiaairport.com http://www.joecooperfordtulsa.com http://www.valenciaacura.com http://www.lumsautocenter.com http://www.harrisisuzu.com))
        # /meet-our-staff/


        ###### Dealer Inspire STAFF PAGE
        ### (HELP!!) ### DUPLICATE DATA B/C FLUID AND STATIC VERSION.
        # indexers = Indexer.where(template: "Dealer Inspire")[a...z]
        # indexers = Indexer.where(clean_url: "http://www.garberbuickgmc.com")  ## /about-us/staff/
        # indexers = Indexer.where(clean_url: "http://www.fiatoftacoma.com")  ## /about-us/staff/
        # indexers = Indexer.where(clean_url: "http://www.commonwealthhonda.com")  ## /about-us/staff/

        # http://www.clevelandmotorsports.com/about-us/meet-our-staff/
        # https://www.palmerstoyota.com/about-us/meet-our-staff/
        # https://www.pretoy.com/team/
        # http://www.landroverpalmbeach.com/staff/

        # http://www.clevelandmotorsports.com/about-us/meet-our-staff/
        # https://www.palmerstoyota.com/about-us/meet-our-staff/
        # https://www.pretoy.com/team/
        # http://www.landroverpalmbeach.com/staff/

        # MEET OUR STAFF
        # Meet Our Staff
        # MEET OUR TEAM
        # OUR TEAM


        ###### (*DONE!) DEALER.com STAFF PAGE
        # indexers = Indexer.where(template: "Dealer.com")[a...z]
        # indexers = Indexer.where(clean_url: "http://www.bobbellford.net")
        # indexers = Indexer.where(clean_url: "http://www.norrishonda.com")
        # indexers = Indexer.where(clean_url: "http://www.hallmarkvw.com")
        # indexers = Indexer.where(clean_url: "http://www.fairoaksmotors.com")

        ###### (*DONE!)  Dealer Direct STAFF PAGE
        # indexers = Indexer.where(template: "Dealer Direct")[a...z]
        # indexers = Indexer.where(clean_url: "http://www.larrygewekeford.net")
        # indexers = Indexer.where(clean_url: "http://www.thinkfullerford.com")
        # indexers = Indexer.where(clean_url: "http://www.acrivelliford.com")
        # indexers = Indexer.where(clean_url: "http://www.midwayfordtruck.com")
        # indexers = Indexer.where(clean_url: "http://www.kelleher-ford.com")
        # indexers = Indexer.where(clean_url: "http://www.dovecreekford.com")
        # indexers = Indexer.where(clean_url: "http://www.salesfordlincoln.com")
        # indexers = Indexer.where(clean_url: "http://www.boeckmanford.net")
        # indexers = Indexer.where(clean_url: "http://milwaukeeford.com")

        ###### (*DONE!) DealerOn STAFF PAGE
        # indexers = Indexer.where(template: "DealerOn")[a...z]
        # indexers = Indexer.where(clean_url: "http://www.vwmankato.com")
        # indexers = Indexer.where(clean_url: "http://www.laurelkia.com")
        # indexers = Indexer.where(clean_url: "http://www.dalehoward.com")
        # indexers = Indexer.where(clean_url: "http://www.porscheofranchomirage.com")
        # indexers = Indexer.where(clean_url: "http://www.borcherding.com")
        # indexers = Indexer.where(clean_url: "http://www.mywhalingcity.com")
        # /staff.aspx


        counter=0
        range = z-a
        indexers.each do |indexer|
            template = indexer.template
            # clean_url = indexer.clean_url
            # clean_url = indexer.clean_url
            url = indexer.staff_url

            # case template
            # when "Dealer.com"
            #     url = "#{clean_url}/dealership/staff.htm"
            # when "DealerOn"
            #     url = "#{clean_url}/staff.aspx"
            # when "Cobalt"
            #     url = "#{clean_url}/MeetOurDepartments"
            #     # url = "#{clean_url}/MeetOurStaff/staff.htm"
            #     # url = "#{clean_url}/Meet-Our-Staff/staff.htm"
            #     # url = "#{clean_url}/Staff/staff.htm"
            #     # url = "#{clean_url}/dealership/staff.htm"
            # when "Dealer Direct"
            #     url = "#{clean_url}/staff"
            # when "Dealer Inspire"
            #     url = "#{clean_url}/about-us/staff/"
            #     # url = "#{clean_url}/team/"
            #     # url = "#{clean_url}/staff/"
            # when "DealerFire"
            #     # url = "#{clean_url}/team-don-jacobs-volkswagen-in-lexington-ky"
            #     # url = "#{clean_url}/team-payne-weslaco-ford-in-weslaco-tx"
            #     # url = "#{clean_url}/team-palmen-in-racine-kenosha-wi"
            #     # url = "#{clean_url}/team-volkswagen-north-hills-in-wexford-pa"
            #     url = "#{clean_url}/team-perry-honda-in-bishop-ca"
            #     # url = "#{clean_url}/team-jc-billion-nissan-in-bozeman-mt"
            # when "DEALER eProcess"
            #     url = "#{clean_url}/meet-our-staff"
            # when "DealerCar Search"
            #     # url = "#{clean_url}/"
            # end

            counter+=1
            puts "\n============================\n"
            puts "[#{a}...#{z}]  (#{counter}/#{range})"

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

                # indexer.update_attributes(indexer_status: "CS Error", cs_sts: cs_error_code)
            end ## rescue ends

            sleep(3)
        end ## .each loop ends

    end
end
