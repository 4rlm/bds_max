require 'csv'

class Staffer < ApplicationRecord
    include Filterable

        # == Multi-Select Search ==
        scope :staffer_status, -> (staffer_status) { where staffer_status: staffer_status }

        # == Key Word Search ==
        scope :cont_status, -> (cont_status) { where("cont_status like ?", "%#{cont_status}%") }
        scope :cont_source, -> (cont_source) { where("cont_source like ?", "%#{cont_source}%") }
        scope :sfdc_id, -> (sfdc_id) { where("sfdc_id like ?", "%#{sfdc_id}%") }
        scope :sfdc_sales_person, -> (sfdc_sales_person) { where("sfdc_sales_person like ?", "%#{sfdc_sales_person}%") }
        scope :sfdc_type, -> (sfdc_type) { where("sfdc_type like ?", "%#{sfdc_type}%") }
        scope :acct_name, -> (acct_name) { where("acct_name like ?", "%#{acct_name}%") }
        scope :group_name, -> (group_name) { where("group_name like ?", "%#{group_name}%") }
        scope :ult_group_name, -> (ult_group_name) { where("ult_group_name like ?", "%#{ult_group_name}%") }
        scope :street, -> (street) { where("street like ?", "%#{street}%") }
        scope :city, -> (city) { where("city like ?", "%#{city}%") }
        scope :state, -> (state) { where("state like ?", "%#{state}%") }
        scope :zip, -> (zip) { where("zip like ?", "%#{zip}%") }
        scope :sfdc_cont_active, -> (sfdc_cont_active) { where("sfdc_cont_active like ?", "%#{sfdc_cont_active}%") }
        scope :sfdc_cont_id, -> (sfdc_cont_id) { where("sfdc_cont_id like ?", "%#{sfdc_cont_id}%") }
        scope :fname, -> (fname) { where("fname like ?", "%#{fname}%") }
        scope :lname, -> (lname) { where("lname like ?", "%#{lname}%") }
        scope :fullname, -> (fullname) { where("fullname like ?", "%#{fullname}%") }
        scope :job, -> (job) { where("job like ?", "%#{job}%") }
        scope :job_raw, -> (job_raw) { where("job_raw like ?", "%#{job_raw}%") }
        scope :phone, -> (phone) { where("phone like ?", "%#{phone}%") }
        scope :email, -> (email) { where("email like ?", "%#{email}%") }
        scope :influence, -> (influence) { where("influence like ?", "%#{influence}%") }
        scope :template, -> (template) { where("template like ?", "%#{template}%") }
        scope :staffer_date, -> (staffer_date) { where("staffer_date like ?", "%#{staffer_date}%") }
        scope :staff_link, -> (staff_link) { where("staff_link like ?", "%#{staff_link}%") }
        scope :staff_text, -> (staff_text) { where("staff_text like ?", "%#{staff_text}%") }
        scope :sfdc_tier, -> (sfdc_tier) { where("sfdc_tier like ?", "%#{sfdc_tier}%") }
        scope :domain, -> (domain) { where("domain like ?", "%#{domain}%") }
        scope :cell_phone, -> (cell_phone) { where("cell_phone like ?", "%#{cell_phone}%") }
        scope :franchise, -> (franchise) { where("franchise like ?", "%#{franchise}%") }
        scope :created_date, -> (created_date) { where("created_date like ?", "%#{created_date}%") }
        scope :updated_date, -> (updated_date) { where("updated_date like ?", "%#{updated_date}%") }
        scope :last_activity_date, -> (last_activity_date) { where("last_activity_date like ?", "%#{last_activity_date}%") }




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
