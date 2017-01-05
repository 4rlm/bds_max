require 'mechanize'
require 'nokogiri'
require 'open-uri'
require_relative 'staffer_service_helper'

class StafferService
    def start_staffer(ids)
        Core.where(id: ids).each do |el|
            current_time = Time.new

            @cols_hash = {
                sfdc_id: el[:sfdc_id],
                sfdc_acct: el[:sfdc_acct],
                sfdc_group: el[:sfdc_group],
                sfdc_ult_grp: el[:sfdc_ult_grp],
                sfdc_sales_person: el[:sfdc_sales_person],
                sfdc_type: el[:sfdc_type],
                sfdc_tier: el[:sfdc_tier],
                staff_link: el[:staff_link],
                staff_text: el[:staff_text],
                domain: el[:matched_url],
                staffer_date: current_time,
                staffer_status: nil,
                template: nil,
                site_acct: nil,
                site_street: nil,
                site_city: nil,
                site_state: nil,
                site_zip: nil,
                site_ph: nil,
                site_cont_job_raw: nil,
                site_cont_fname: nil,
                site_cont_lname: nil,
                site_cont_fullname: nil,
                site_cont_email: nil,
                cont_status: nil,
                cont_source: nil,
                site_cont_influence: nil
            }

            search(el, @cols_hash[:staff_link])

            el.update_attributes(staffer_date: current_time, bds_status: "Staffer Result")

        end # cores Loop - Ends
    end # start_staffer(ids) - Ends

    def search(core, url)
        begin
            temp_list = [ 'DDC', 'dealeron', 'cobalt', 'DealerFire', 'di_homepage' ]

            @agent = Mechanize.new
            doc = @agent.get(url)
            detect =  false

            for term in temp_list
                if doc.at_css('head').text.include?(term)
                    detect = true
                    temp_method(term, doc, url)
                end
            end

            unless detect
                core.update_attribute(:staffer_status, "Temp Error")
                puts "\n\n===== Template Unidentified =====\n\n"
            end
        rescue
            core.update_attribute(:staffer_status, "Search Error")
            puts "\n\n===== StafferService#search Error: #{$!.message} =====\n\n"
        end

        #== Throttle (if needed) =====================
        throttle_delay_time = (1..5).to_a.sample
        puts "Completed"
        puts "Please wait #{throttle_delay_time} seconds."
        puts "--------------------------------"
        sleep(throttle_delay_time)

    end

    def temp_method(term, doc, url)
        sc = Scrapers.new(@cols_hash)
        domain = @cols_hash[:domain]

        case term
        when "DDC"
            sc.ddc_scraper(doc, url)
            diff_staff_url_for_ddc(sc, url, domain)
            puts "\n\n===== Found: Dealer.com =====\n\n"
        when "dealeron"
            sc.do_scraper(doc, url)
            puts "\n\n===== Found: DealerOn.com =====\n\n"
        when "cobalt"
            sc.cobalt_scraper(doc, url)
            puts "\n\n===== Found: Cobalt.com =====\n\n"
        when "DealerFire"
            sc.df_scraper(doc, url)
            puts "\n\n===== Found: DealerFire.com =====\n\n"
        when "di_homepage"
            sc.di_scraper(doc, url)
            puts "\n\n===== Found: DealerInspire.com =====\n\n"
        end
    end

    def diff_staff_url_for_ddc(scrapers_obj, url, domain)
        staff_url = domain + "dealership/staff.htm"
        if url != staff_url
            staff_docu = @agent.get(staff_url)
            scrapers_obj.ddc_scraper(staff_docu, staff_url)
            puts "\n\n===== Different staff url for ddc =====\n\n"
        end
    end

end
