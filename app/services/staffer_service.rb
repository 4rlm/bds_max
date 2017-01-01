require 'mechanize'
require 'nokogiri'
require 'open-uri'
# require_relative 'Core_MaxContacts.rb'
# require_relative 'Reader_MaxContacts.rb'

class StafferService
    def start_staffer(ids)
        # agent = Mechanize.new

        Core.where(id: ids).each do |el|
            current_time = Time.new

            @cols_hash = {
                staffer_status: nil,
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
                staffer_date: current_time
            }

            add_indexer_row_with("No Matches")

            el.update_attributes(staffer_date: current_time, bds_status: "Staffer Result")

        end # cores Loop - Ends
    end # start_staffer(ids) - Ends

    def add_indexer_row_with(status)
        @cols_hash[:staffer_status] = status
        core = Core.find_by(sfdc_id: @cols_hash[:sfdc_id])

        Staffer.create(@cols_hash)
        core.update_attributes(staffer_status: status)
    end

end
