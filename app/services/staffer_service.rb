require 'mechanize'
require 'nokogiri'
require 'open-uri'
# require_relative 'Core_MaxContacts.rb'
# require_relative 'Reader_MaxContacts.rb'

class TempFinder
    def diff_staff_url(scrapers_obj, url, id, domain)
        # If url is NOT "http://www.example.com/dealership/staff.htm",
        # then add another row with the url("http://www.example.com/dealership/staff.htm").
        staff_url = domain + "dealership/staff.htm"
        if url != staff_url
            agent = Mechanize.new
            staff_docu = agent.get(staff_url)

            scrapers_obj.ddc_scraper(staff_docu, staff_url, id, domain)
            puts ">> Added row with staff url"
        end
    end

    def temp_method(item, docu, url, id, domain)
        sc = Scrapers.new

        case item
        when "DDC"
            sc.ddc_scraper(docu, url, id, domain)
            puts "Found DDC on Dealer.com template."
            diff_staff_url(sc, url, id, domain)
        when "dealeron"
            sc.do_scraper(docu, url, id, domain)
            puts "Found dealeron on DealerOn.com template."
            diff_staff_url(sc, url, id, domain)
        when "cobalt"
            sc.cobalt_scraper(docu, url, id, domain)
            puts "Found cobalt on Cobalt.com template."
            diff_staff_url(sc, url, id, domain)
        when "DealerFire"
            sc.df_scraper(docu, url, id, domain)
            puts "Found DealerFire on DealerFire.com template."
            diff_staff_url(sc, url, id, domain)
        when "di_homepage"
            sc.di_scraper(docu, url, id, domain)
            puts "Found di_homepage on DealerInspire.com template."
            diff_staff_url(sc, url, id, domain)
        else
            puts "Template Version Unidentified."
        end
    end

    def search(url_list)
        temp_list = [ 'DDC', 'dealeron', 'cobalt', 'DealerFire', 'di_homepage' ]
        urls = url_list.map {|hash| hash[:url]}

        urls.each do |url|
            begin
                agent = Mechanize.new
                doc = agent.get(url)

                result = false

                for i in 0...(temp_list.length)
                    verify = doc.at_css('head').text.include?(temp_list[i])

                    if verify
                        result = true
                        url_hash = url_list[urls.index(url)]
                        id = url_hash[:id]
                        domain = url_hash[:domain]
                        temp_method(temp_list[i], doc, url, id, domain)
                    end
                end

                unless result
                    puts "NOT FOUND"   # No matching Template
                end
            rescue
                puts ">>>> URI:ERR OR ERROR"
            end

        end
    end
end
