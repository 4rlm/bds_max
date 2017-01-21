require 'csv'

class Core < ApplicationRecord
    include Filterable

    # == Multi-Select Search ==
    scope :bds_status, -> (bds_status) { where bds_status: bds_status }
    scope :staff_indexer_status, -> (staff_indexer_status) { where staff_indexer_status: staff_indexer_status }
    scope :location_indexer_status, -> (location_indexer_status) { where location_indexer_status: location_indexer_status }
    scope :inventory_indexer_status, -> (inventory_indexer_status) { where inventory_indexer_status: inventory_indexer_status }
    scope :staffer_status, -> (staffer_status) { where staffer_status: staffer_status }
    scope :sfdc_sales_person, -> (sfdc_sales_person) { where sfdc_sales_person: sfdc_sales_person }
    scope :sfdc_tier, -> (sfdc_tier) { where sfdc_tier: sfdc_tier }
    scope :site_tier, -> (site_tier) { where site_tier: site_tier }
    scope :sfdc_type, -> (sfdc_type) { where sfdc_type: sfdc_type }
    scope :url_comparison, -> (url_comparison) { where url_comparison: url_comparison }
    scope :root_comparison, -> (root_comparison) { where root_comparison: root_comparison }
    scope :acct_indicator, -> (acct_indicator) { where acct_indicator: acct_indicator }
    scope :grp_name_indicator, -> (grp_name_indicator) { where grp_name_indicator: grp_name_indicator }
    scope :ult_grp_name_indicator, -> (ult_grp_name_indicator) { where ult_grp_name_indicator: ult_grp_name_indicator }
    scope :tier_indicator, -> (tier_indicator) { where tier_indicator: tier_indicator }
    scope :grp_rt_indicator, -> (grp_rt_indicator) { where grp_rt_indicator: grp_rt_indicator }
    scope :ult_grp_rt_indicator, -> (ult_grp_rt_indicator) { where ult_grp_rt_indicator: ult_grp_rt_indicator }
    scope :street_indicator, -> (street_indicator) { where street_indicator: street_indicator }
    scope :city_indicator, -> (city_indicator) { where city_indicator: city_indicator }
    scope :state_indicator, -> (state_indicator) { where state_indicator: state_indicator }
    scope :zip_indicator, -> (zip_indicator) { where zip_indicator: zip_indicator }
    scope :ph_indicator, -> (ph_indicator) { where ph_indicator: ph_indicator }

    scope :sfdc_geo_status, -> (sfdc_geo_status) { where sfdc_geo_status: sfdc_geo_status }
    scope :site_geo_status, -> (site_geo_status) { where site_geo_status: site_geo_status }

    scope :site_franchise, -> (site_franchise) { where site_franchise: site_franchise }
    scope :sfdc_franchise, -> (sfdc_franchise) { where sfdc_franchise: sfdc_franchise }
    scope :site_franch_cat, -> (site_franch_cat) { where site_franch_cat: site_franch_cat }
    scope :sfdc_franch_cat, -> (sfdc_franch_cat) { where sfdc_franch_cat: sfdc_franch_cat }
    scope :sfdc_franch_cons, -> (sfdc_franch_cons) { where sfdc_franch_cons: sfdc_franch_cons }
    scope :site_franch_cons, -> (site_franch_cons) { where site_franch_cons: site_franch_cons }
    scope :coord_indicator, -> (coord_indicator) { where coord_indicator: coord_indicator }


    # == Key Word Search ==
    scope :sfdc_id, -> (sfdc_id) { where("sfdc_id like ?", "%#{sfdc_id}%") }
    scope :sfdc_ult_rt, -> (sfdc_ult_rt) { where("sfdc_ult_rt like ?", "%#{sfdc_ult_rt}%") }
    scope :site_ult_rt, -> (site_ult_rt) { where("site_ult_rt like ?", "%#{site_ult_rt}%") }
    scope :sfdc_grp_rt, -> (sfdc_grp_rt) { where("sfdc_grp_rt like ?", "%#{sfdc_grp_rt}%") }
    scope :site_grp_rt, -> (site_grp_rt) { where("site_grp_rt like ?", "%#{site_grp_rt}%") }
    scope :sfdc_ult_grp, -> (sfdc_ult_grp) { where("sfdc_ult_grp like ?", "%#{sfdc_ult_grp}%") }
    scope :site_ult_grp, -> (site_ult_grp) { where("site_ult_grp like ?", "%#{site_ult_grp}%") }
    scope :sfdc_group, -> (sfdc_group) { where("sfdc_group like ?", "%#{sfdc_group}%") }
    scope :site_group, -> (site_group) { where("site_group like ?", "%#{site_group}%") }
    scope :sfdc_acct, -> (sfdc_acct) { where("sfdc_acct like ?", "%#{sfdc_acct}%") }
    scope :site_acct, -> (site_acct) { where("site_acct like ?", "%#{site_acct}%") }
    scope :sfdc_street, -> (sfdc_street) { where("sfdc_street like ?", "%#{sfdc_street}%") }
    scope :site_street, -> (site_street) { where("site_street like ?", "%#{site_street}%") }
    scope :sfdc_city, -> (sfdc_city) { where("sfdc_city like ?", "%#{sfdc_city}%") }
    scope :site_city, -> (site_city) { where("site_city like ?", "%#{site_city}%") }
    scope :sfdc_state, -> (sfdc_state) { where("sfdc_state like ?", "%#{sfdc_state}%") }
    scope :site_state, -> (site_state) { where("site_state like ?", "%#{site_state}%") }
    scope :sfdc_zip, -> (sfdc_zip) { where("sfdc_zip like ?", "%#{sfdc_zip}%") }
    scope :site_zip, -> (site_zip) { where("site_zip like ?", "%#{site_zip}%") }
    scope :sfdc_ph, -> (sfdc_ph) { where("sfdc_ph like ?", "%#{sfdc_ph}%") }
    scope :sfdc_url, -> (sfdc_url) { where("sfdc_url like ?", "%#{sfdc_url}%") }
    scope :site_ph, -> (site_ph) { where("site_ph like ?", "%#{site_ph}%") }
    scope :matched_url, -> (matched_url) { where("matched_url like ?", "%#{matched_url}%") }
    scope :matched_root, -> (matched_root) { where("matched_root like ?", "%#{matched_root}%") }
    scope :sfdc_root, -> (sfdc_root) { where("sfdc_root like ?", "%#{sfdc_root}%") }

    scope :sfdc_lat, -> (sfdc_lat) { where("sfdc_lat like ?", "%#{sfdc_lat}%") }
    scope :sfdc_lon, -> (sfdc_lon) { where("sfdc_lon like ?", "%#{sfdc_lon}%") }
    scope :site_lat, -> (site_lat) { where("site_lat like ?", "%#{site_lat}%") }
    scope :site_lon, -> (site_lon) { where("site_lon like ?", "%#{site_lon}%") }
    scope :sfdc_geo_date, -> (sfdc_geo_date) { where("sfdc_geo_date like ?", "%#{sfdc_geo_date}%") }
    scope :site_geo_date, -> (site_geo_date) { where("site_geo_date like ?", "%#{site_geo_date}%") }
    scope :sfdc_coordinates, -> (sfdc_coordinates) { where("sfdc_coordinates like ?", "%#{sfdc_coordinates}%") }
    scope :site_coordinates, -> (site_coordinates) { where("site_coordinates like ?", "%#{site_coordinates}%") }



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
