require 'csv'

class Core < ApplicationRecord
    include Filterable

    # == Multi-Select Search ==
    scope :bds_status, -> (bds_status) { where bds_status: bds_status }

    scope :staff_indexer_status, -> (staff_indexer_status) { where staff_indexer_status: staff_indexer_status }
    scope :location_indexer_status, -> (location_indexer_status) { where location_indexer_status: location_indexer_status }
    scope :inventory_indexer_status, -> (inventory_indexer_status) { where inventory_indexer_status: inventory_indexer_status }

    scope :sfdc_sales_person, -> (sfdc_sales_person) { where sfdc_sales_person: sfdc_sales_person }
    scope :sfdc_tier, -> (sfdc_tier) { where sfdc_tier: sfdc_tier }
    scope :sfdc_type, -> (sfdc_type) { where sfdc_type: sfdc_type }
    scope :url_comparison, -> (url_comparison) { where url_comparison: url_comparison }
    scope :root_comparison, -> (root_comparison) { where root_comparison: root_comparison }

    # == Key Word Search ==
    scope :sfdc_id, -> (sfdc_id) { where("sfdc_id like ?", "%#{sfdc_id}%") }
    # scope :sfdc_ult_rt, -> (sfdc_ult_rt) { where sfdc_ult_rt: sfdc_ult_rt }
    scope :sfdc_ult_rt, -> (sfdc_ult_rt) { where("sfdc_ult_rt like ?", "%#{sfdc_ult_rt}%") }
    # scope :sfdc_grp_rt, -> (sfdc_grp_rt) { where sfdc_grp_rt: sfdc_grp_rt }
    scope :sfdc_grp_rt, -> (sfdc_grp_rt) { where("sfdc_grp_rt like ?", "%#{sfdc_grp_rt}%") }
    # scope :sfdc_ult_grp, -> (sfdc_ult_grp) { where sfdc_ult_grp: sfdc_ult_grp }
    scope :sfdc_ult_grp, -> (sfdc_ult_grp) { where("sfdc_ult_grp like ?", "%#{sfdc_ult_grp}%") }
    # scope :sfdc_group, -> (sfdc_group) { where sfdc_group: sfdc_group }
    scope :sfdc_group, -> (sfdc_group) { where("sfdc_group like ?", "%#{sfdc_group}%") }
    # scope :sfdc_acct, -> (sfdc_acct) { where sfdc_acct: sfdc_acct }
    scope :sfdc_acct, -> (sfdc_acct) { where("sfdc_acct like ?", "%#{sfdc_acct}%") }
    # scope :sfdc_street, -> (sfdc_street) { where sfdc_street: sfdc_street }
    scope :sfdc_street, -> (sfdc_street) { where("sfdc_street like ?", "%#{sfdc_street}%") }
    # scope :sfdc_city, -> (sfdc_city) { where sfdc_city: sfdc_city }
    scope :sfdc_city, -> (sfdc_city) { where("sfdc_city like ?", "%#{sfdc_city}%") }
    # scope :sfdc_state, -> (sfdc_state) { where sfdc_state: sfdc_state }
    scope :sfdc_state, -> (sfdc_state) { where("sfdc_state like ?", "%#{sfdc_state}%") }
    # scope :sfdc_zip, -> (sfdc_zip) { where sfdc_zip: sfdc_zip }
    scope :sfdc_zip, -> (sfdc_zip) { where("sfdc_zip like ?", "%#{sfdc_zip}%") }
    # scope :sfdc_ph, -> (sfdc_ph) { where sfdc_ph: sfdc_ph }
    scope :sfdc_ph, -> (sfdc_ph) { where("sfdc_ph like ?", "%#{sfdc_ph}%") }
    # scope :sfdc_url, -> (sfdc_url) { where sfdc_url: sfdc_url }
    scope :sfdc_url, -> (sfdc_url) { where("sfdc_url like ?", "%#{sfdc_url}%") }
    # scope :matched_url, -> (matched_url) { where matched_url: matched_url }
    scope :matched_url, -> (matched_url) { where("matched_url like ?", "%#{matched_url}%") }
    # scope :matched_root, -> (matched_root) { where matched_root: matched_root }
    scope :matched_root, -> (matched_root) { where("matched_root like ?", "%#{matched_root}%") }
    # scope :sfdc_root, -> (root_comparison) { where sfdc_root: root_comparison }
    scope :sfdc_root, -> (sfdc_root) { where("sfdc_root like ?", "%#{sfdc_root}%") }


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
            row_hash[:core_date] = Time.new

            # ========= CSV column formatting =========
            # Capitalize columns
            row_hash[:bds_status] = Core.capitalized(row_hash["bds_status"])
            row_hash[:sfdc_tier] = Core.capitalized(row_hash["sfdc_tier"])
            row_hash[:sfdc_sales_person] = Core.capitalized(row_hash["sfdc_sales_person"])
            row_hash[:sfdc_type] = Core.capitalized(row_hash["sfdc_type"])
            row_hash[:sfdc_ult_grp] = Core.capitalized(row_hash["sfdc_ult_grp"])
            row_hash[:sfdc_group] = Core.capitalized(row_hash["sfdc_group"])
            row_hash[:sfdc_acct] = Core.capitalized(row_hash["sfdc_acct"])
            row_hash[:sfdc_street] = Core.capitalized(row_hash["sfdc_street"])
            row_hash[:sfdc_city] = Core.capitalized(row_hash["sfdc_city"])

            # Upcase column
            row_hash[:sfdc_state] = Core.upcased(row_hash["sfdc_state"])

            # Downcase columns
            row_hash[:sfdc_url] = Core.downcased(row_hash["sfdc_url"])
            row_hash[:sfdc_root] = Core.downcased(row_hash["sfdc_root"])
            # ========= Ends CSV column formatting =========

            Core.create!(row_hash)
        end
    end

    # ========= CSV column formatting =========
    def self.capitalized(str)
        str.split.map(&:capitalize)*" " unless str.nil?
    end

    def self.upcased(str)
        str.upcase unless str.nil?
    end

    def self.downcased(str)
        str.downcase unless str.nil?
    end
    # ========= Ends CSV column formatting =========
end
