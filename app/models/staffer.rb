require 'csv'

class Staffer < ApplicationRecord
    include Filterable

        # == Multi-Select Search ==
        scope :staffer_status, -> (staffer_status) { where staffer_status: staffer_status }
        # scope :cont_status, -> (cont_status) { where cont_status: cont_status }
        # scope :cont_source, -> (cont_source) { where cont_source: cont_source }
        # scope :sfdc_id, -> (sfdc_id) { where sfdc_id: sfdc_id }
        # scope :sfdc_sales_person, -> (sfdc_sales_person) { where sfdc_sales_person: sfdc_sales_person }
        # scope :sfdc_type, -> (sfdc_type) { where sfdc_type: sfdc_type }
        # scope :sfdc_acct, -> (sfdc_acct) { where sfdc_acct: sfdc_acct }
        # scope :site_acct, -> (site_acct) { where site_acct: site_acct }
        # scope :sfdc_group, -> (sfdc_group) { where sfdc_group: sfdc_group }
        # scope :sfdc_ult_grp, -> (sfdc_ult_grp) { where sfdc_ult_grp: sfdc_ult_grp }
        # scope :site_street, -> (site_street) { where site_street: site_street }
        # scope :site_city, -> (site_city) { where site_city: site_city }
        # scope :site_state, -> (site_state) { where site_state: site_state }
        # scope :site_zip, -> (site_zip) { where site_zip: site_zip }
        # scope :site_ph, -> (site_ph) { where site_ph: site_ph }
        # scope :sfdc_cont_fname, -> (sfdc_cont_fname) { where sfdc_cont_fname: sfdc_cont_fname }
        # scope :sfdc_cont_lname, -> (sfdc_cont_lname) { where sfdc_cont_lname: sfdc_cont_lname }
        # scope :sfdc_cont_job, -> (sfdc_cont_job) { where sfdc_cont_job: sfdc_cont_job }
        # scope :sfdc_cont_phone, -> (sfdc_cont_phone) { where sfdc_cont_phone: sfdc_cont_phone }
        # scope :sfdc_cont_email, -> (sfdc_cont_email) { where sfdc_cont_email: sfdc_cont_email }
        # scope :sfdc_cont_active, -> (sfdc_cont_active) { where sfdc_cont_active: sfdc_cont_active }
        # scope :sfdc_cont_id, -> (sfdc_cont_id) { where sfdc_cont_id: sfdc_cont_id }
        # scope :sfdc_cont_influence, -> (sfdc_cont_influence) { where sfdc_cont_influence: sfdc_cont_influence }
        # scope :site_cont_fname, -> (site_cont_fname) { where site_cont_fname: site_cont_fname }
        # scope :site_cont_lname, -> (site_cont_lname) { where site_cont_lname: site_cont_lname }
        # scope :site_cont_fullname, -> (site_cont_fullname) { where site_cont_fullname: site_cont_fullname }
        # scope :site_cont_job, -> (site_cont_job) { where site_cont_job: site_cont_job }
        # scope :site_cont_job_raw, -> (site_cont_job_raw) { where site_cont_job_raw: site_cont_job_raw }
        # scope :site_cont_phone, -> (site_cont_phone) { where site_cont_phone: site_cont_phone }
        # scope :site_cont_email, -> (site_cont_email) { where site_cont_email: site_cont_email }
        # scope :site_cont_influence, -> (site_cont_influence) { where site_cont_influence: site_cont_influence }
        # scope :template, -> (template) { where template: template }
        # scope :staffer_date, -> (staffer_date) { where staffer_date: staffer_date }

        # scope :staff_link, -> (staff_link) { where staff_link: staff_link }
        # scope :staff_text, -> (staff_text) { where staff_text: staff_text }
        # scope :sfdc_tier, -> (sfdc_tier) { where sfdc_tier: sfdc_tier }
        # scope :domain, -> (domain) { where domain: domain }



        # == Key Word Search ==
        # scope :staffer_status, -> (staffer_status) { where("staffer_status like ?", "%#{staffer_status}%") }
        scope :cont_status, -> (cont_status) { where("cont_status like ?", "%#{cont_status}%") }
        scope :cont_source, -> (cont_source) { where("cont_source like ?", "%#{cont_source}%") }
        scope :sfdc_id, -> (sfdc_id) { where("sfdc_id like ?", "%#{sfdc_id}%") }
        scope :sfdc_sales_person, -> (sfdc_sales_person) { where("sfdc_sales_person like ?", "%#{sfdc_sales_person}%") }
        scope :sfdc_type, -> (sfdc_type) { where("sfdc_type like ?", "%#{sfdc_type}%") }
        scope :sfdc_acct, -> (sfdc_acct) { where("sfdc_acct like ?", "%#{sfdc_acct}%") }
        scope :site_acct, -> (site_acct) { where("site_acct like ?", "%#{site_acct}%") }
        scope :sfdc_group, -> (sfdc_group) { where("sfdc_group like ?", "%#{sfdc_group}%") }
        scope :sfdc_ult_grp, -> (sfdc_ult_grp) { where("sfdc_ult_grp like ?", "%#{sfdc_ult_grp}%") }
        scope :site_street, -> (site_street) { where("site_street like ?", "%#{site_street}%") }
        scope :site_city, -> (site_city) { where("site_city like ?", "%#{site_city}%") }
        scope :site_state, -> (site_state) { where("site_state like ?", "%#{site_state}%") }
        scope :site_zip, -> (site_zip) { where("site_zip like ?", "%#{site_zip}%") }
        scope :site_ph, -> (site_ph) { where("site_ph like ?", "%#{site_ph}%") }
        scope :sfdc_cont_fname, -> (sfdc_cont_fname) { where("sfdc_cont_fname like ?", "%#{sfdc_cont_fname}%") }
        scope :sfdc_cont_lname, -> (sfdc_cont_lname) { where("sfdc_cont_lname like ?", "%#{sfdc_cont_lname}%") }
        scope :sfdc_cont_job, -> (sfdc_cont_job) { where("sfdc_cont_job like ?", "%#{sfdc_cont_job}%") }
        scope :sfdc_cont_phone, -> (sfdc_cont_phone) { where("sfdc_cont_phone like ?", "%#{sfdc_cont_phone}%") }
        scope :sfdc_cont_email, -> (sfdc_cont_email) { where("sfdc_cont_email like ?", "%#{sfdc_cont_email}%") }
        scope :sfdc_cont_active, -> (sfdc_cont_active) { where("sfdc_cont_active like ?", "%#{sfdc_cont_active}%") }
        scope :sfdc_cont_id, -> (sfdc_cont_id) { where("sfdc_cont_id like ?", "%#{sfdc_cont_id}%") }
        scope :sfdc_cont_influence, -> (sfdc_cont_influence) { where("sfdc_cont_influence like ?", "%#{sfdc_cont_influence}%") }
        scope :site_cont_fname, -> (site_cont_fname) { where("site_cont_fname like ?", "%#{site_cont_fname}%") }
        scope :site_cont_lname, -> (site_cont_lname) { where("site_cont_lname like ?", "%#{site_cont_lname}%") }
        scope :site_cont_fullname, -> (site_cont_fullname) { where("site_cont_fullname like ?", "%#{site_cont_fullname}%") }
        scope :site_cont_job, -> (site_cont_job) { where("site_cont_job like ?", "%#{site_cont_job}%") }
        scope :site_cont_job_raw, -> (site_cont_job_raw) { where("site_cont_job_raw like ?", "%#{site_cont_job_raw}%") }
        scope :site_cont_phone, -> (site_cont_phone) { where("site_cont_phone like ?", "%#{site_cont_phone}%") }
        scope :site_cont_email, -> (site_cont_email) { where("site_cont_email like ?", "%#{site_cont_email}%") }
        scope :site_cont_influence, -> (site_cont_influence) { where("site_cont_influence like ?", "%#{site_cont_influence}%") }
        scope :template, -> (template) { where("template like ?", "%#{template}%") }
        scope :staffer_date, -> (staffer_date) { where("staffer_date like ?", "%#{staffer_date}%") }
        scope :staff_link, -> (staff_link) { where("staff_link like ?", "%#{staff_link}%") }
        scope :staff_text, -> (staff_text) { where("staff_text like ?", "%#{staff_text}%") }
        scope :sfdc_tier, -> (sfdc_tier) { where("sfdc_tier like ?", "%#{sfdc_tier}%") }
        scope :domain, -> (domain) { where("domain like ?", "%#{site_cont_email}%") }


        def self.to_csv
            CSV.generate do |csv|
              csv << column_names
              all.each do |x|
                csv << x.attributes.values_at(*column_names)
              end
            end
          end

          def self.import_csv(file_name)
              CSV.foreach(file_name.path, headers: true, skip_blanks: true) do |row|
                  row_hash = row.to_hash
                  Staffer.create!(row_hash)
              end
          end

end
