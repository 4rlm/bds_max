require 'csv'

class Core < ApplicationRecord
    include Filterable

    scope :bds_status, -> (bds_status) { where bds_status: bds_status }
    scope :sfdc_id, -> (sfdc_id) { where("sfdc_id like ?", "%#{sfdc_id}%") }
    scope :sfdc_ult_grp, -> (sfdc_ult_grp) { where("sfdc_ult_grp like ?", "%#{sfdc_ult_grp}%") }
    scope :sfdc_acct, -> (sfdc_acct) { where("sfdc_acct like ?", "%#{sfdc_acct}%") }
    scope :sfdc_type, -> (sfdc_type) { where sfdc_type: sfdc_type }
    scope :sfdc_street, -> (sfdc_street) { where("sfdc_street like ?", "%#{sfdc_street}%") }
    scope :sfdc_city, -> (sfdc_city) { where sfdc_city: sfdc_city }
    scope :sfdc_state, -> (sfdc_state) { where sfdc_state: sfdc_state }
    scope :sfdc_url, -> (sfdc_url) { where sfdc_url: sfdc_url }

    def self.import_csv(file_name)
        CSV.foreach(file_name.path, headers: true, skip_blanks: true) do |row|
            row_hash = row.to_hash
            Core.create!(row_hash)
        end
    end
 end
