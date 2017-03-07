require 'staffer_helper/cs_helper'

class DealerComCs
    def initialize
        @helper = CsHelper.new
    end

    def contact_scraper(html, url, indexer)
        if html.css('#staffList .vcard .fn')
            staff_count = html.css('#staffList .vcard .fn').count
            staff_hash_array = []

            for i in 0...staff_count
                staff_hash = {}
                staff_hash[:full_name] = html.css('#staffList .vcard .fn')[i].text.strip
                staff_hash[:job] = html.css('#staffList .vcard .title') ? html.css('#staffList .vcard .title')[i].text.strip : ""
                staff_hash[:email] = html.css('#staffList .vcard .email') ? html.css('#staffList .vcard .email')[i].text.strip : ""
                staff_hash[:phone] = html.css('#staffList .vcard .phone') ? html.css('#staffList .vcard .phone')[i].text.strip : ""

                staff_hash_array << staff_hash
            end
        end

        @helper.print_result(indexer.template, url, staff_hash_array)
        @helper.prep_create_staffer(staff_hash_array)
    end
end