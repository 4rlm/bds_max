require 'csv'

class Core < ApplicationRecord
    include Filterable

    scope :bds_status, -> (bds_status) { where bds_status: bds_status }
    scope :sfdc_sales_person, -> (sfdc_sales_person) { where sfdc_sales_person: sfdc_sales_person }
    scope :sfdc_id, -> (sfdc_id) { where sfdc_id: sfdc_id }
    scope :sfdc_tier, -> (sfdc_tier) { where sfdc_tier: sfdc_tier }
    scope :sfdc_type, -> (sfdc_type) { where sfdc_type: sfdc_type }
    scope :sfdc_ult_rt, -> (sfdc_ult_rt) { where sfdc_ult_rt: sfdc_ult_rt }
    scope :sfdc_grp_rt, -> (sfdc_grp_rt) { where sfdc_grp_rt: sfdc_grp_rt }
    scope :sfdc_ult_grp, -> (sfdc_ult_grp) { where sfdc_ult_grp: sfdc_ult_grp }
    scope :sfdc_group, -> (sfdc_group) { where sfdc_group: sfdc_group }
    scope :sfdc_acct, -> (sfdc_acct) { where sfdc_acct: sfdc_acct }
    scope :sfdc_street, -> (sfdc_street) { where sfdc_street: sfdc_street }
    scope :sfdc_city, -> (sfdc_city) { where sfdc_city: sfdc_city }
    scope :sfdc_state, -> (sfdc_state) { where sfdc_state: sfdc_state }
    scope :sfdc_zip, -> (sfdc_zip) { where sfdc_zip: sfdc_zip }
    scope :sfdc_ph, -> (sfdc_ph) { where sfdc_ph: sfdc_ph }
    scope :sfdc_url, -> (sfdc_url) { where sfdc_url: sfdc_url }

    def self.to_csv
        CSV.generate do |csv|
          csv << column_names
          all.each do |core|
            csv << core.attributes.values_at(*column_names)
          end
        end
      end

    def self.import_csv(file_name)
        CSV.foreach(file_name.path, headers: true, skip_blanks: true) do |row|
            row_hash = row.to_hash
            Core.create!(row_hash)
        end
    end
 end
