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

            add_indexer_row_with("staffer_status_ex", "template_ex", "site_acct_ex", "site_street_ex", "site_city_ex", "site_state_ex", "site_zip_ex", "site_ph_ex", "site_cont_job_raw_ex", "site_cont_fname_ex", "site_cont_lname_ex", "site_cont_fullname_ex", "site_cont_email_ex", "cont_status_ex", "cont_source_ex", "site_cont_influence_ex")

            el.update_attributes(staffer_date: current_time, bds_status: "Staffer Result")

        end # cores Loop - Ends
    end # start_staffer(ids) - Ends

    def add_indexer_row_with(staffer_status, template, site_acct, site_street, site_city, site_state, site_zip, site_ph, site_cont_job_raw, site_cont_fname, site_cont_lname, site_cont_fullname, site_cont_email, cont_status, cont_source, site_cont_influence)
        @cols_hash[:staffer_status] = staffer_status
        @cols_hash[:template] = template
        @cols_hash[:site_acct] = site_acct
        @cols_hash[:site_street] = site_street
        @cols_hash[:site_city] = site_city
        @cols_hash[:site_state] = site_state
        @cols_hash[:site_zip] = site_zip
        @cols_hash[:site_ph] = site_ph
        @cols_hash[:site_cont_job_raw] = site_cont_job_raw
        @cols_hash[:site_cont_fname] = site_cont_fname
        @cols_hash[:site_cont_lname] = site_cont_lname
        @cols_hash[:site_cont_fullname] = site_cont_fullname
        @cols_hash[:site_cont_email] = site_cont_email
        @cols_hash[:cont_status] = cont_status
        @cols_hash[:cont_source] = cont_source
        @cols_hash[:site_cont_influence] = site_cont_influence

        core = Core.find_by(sfdc_id: @cols_hash[:sfdc_id])

        Staffer.create(@cols_hash)
        core.update_attributes(staffer_status: staffer_status)
    end

end
