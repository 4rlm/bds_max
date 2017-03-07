require 'staffer_helper/cs_helper'

class DealerDirectCs
    def initialize
        @helper = CsHelper.new
    end

    def contact_scraper(html, url, indexer)
        if html.css('.staff-desc .staff-name')
            staff_count = html.css('.staff-desc .staff-name').count
            staff_hash_array = []

            for i in 0...staff_count
                staff_hash = {}
                staff_hash[:full_name] = html.css('.staff-desc .staff-name')[i].text.strip
                staff_hash[:job] = html.css('.staff-desc .staff-title')[i] ? html.css('.staff-desc .staff-title')[i].text.strip : ""
                staff_hash[:email] = html.css('.staff-info .staff-email a')[i] ? html.css('.staff-info .staff-email a')[i].text.strip : ""
                staff_hash[:phone] = html.css('.staff-info .staff-tel')[i] ? html.css('.staff-info .staff-tel')[i].text.strip : ""

                staff_hash_array << staff_hash
            end
        end

        @helper.print_result(indexer.template, url, staff_hash_array)
        @helper.prep_create_staffer(staff_hash_array)
    end
end