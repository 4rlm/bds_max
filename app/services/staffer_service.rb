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

            search(@cols_hash[:staff_link])

            el.update_attributes(staffer_date: current_time, bds_status: "Staffer Result")
        end # cores Loop - Ends
    end # start_staffer(ids) - Ends

    def search(url)
        begin
            temp_list = [ 'DDC', 'dealeron', 'cobalt', 'DealerFire', 'di_homepage' ]

            agent = Mechanize.new
            doc = agent.get(url)

            for term in temp_list
                if doc.at_css('head').text.include?(term)
                    temp_method(term, doc, url)
                end
            end
        rescue
            puts "\n\n===== StafferService#search Error: #{$!.message} =====\n\n"
        end
    end

    def temp_method(term, doc, url)
        sc = Scrapers.new(@cols_hash)
        id = @cols_hash[:sfdc_id]
        domain = @cols_hash[:domain]

        case term
        when "DDC"
            sc.ddc_scraper(doc, url, id, domain)
            diff_staff_url_for_ddc(sc, url, id, domain)
            puts "\n\n===== Found: Dealer.com =====\n\n"
        when "dealeron"
            sc.do_scraper(doc, url, id, domain)
            puts "\n\n===== Found: DealerOn.com =====\n\n"
        when "cobalt"
            sc.cobalt_scraper(doc, url, id, domain)
            puts "\n\n===== Found: Cobalt.com =====\n\n"
        when "DealerFire"
            sc.df_scraper(doc, url, id, domain)
            puts "\n\n===== Found: DealerFire.com =====\n\n"
        when "di_homepage"
            sc.di_scraper(doc, url, id, domain)
            puts "\n\n===== Found: DealerInspire.com =====\n\n"
        else
            puts "\n\n===== Template Unidentified =====\n\n"
        end
    end

    def diff_staff_url_for_ddc(scrapers_obj, url, id, domain)
        staff_url = domain + "dealership/staff.htm"
        if url != staff_url
            agent = Mechanize.new
            staff_docu = agent.get(staff_url)
            scrapers_obj.ddc_scraper(staff_docu, staff_url, id, domain)
            puts "\n\n===== Different staff url for ddc =====\n\n"
        end
    end
end
