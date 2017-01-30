require 'csv'

class Location < ApplicationRecord

# FILTERABLE #
include Filterable

# GEOCODE - GOOGLE - FORWARD #
  geocoded_by :address
  after_validation :geocode, :if => :address_changed?

# GEOCODE - GOOGLE - REVERSE #
    # reverse_geocoded_by :latitude, :longitude
    # after_validation :reverse_geocode  # auto-fetch address

    # reverse_geocoded_by :latitude, :longitude do |obj,results|
    #   if geo = results.first
    #     obj.city    = geo.city
    #     obj.zipcode = geo.postal_code
    #     obj.country = geo.country_code
    #   end
    # end
    # after_validation :reverse_geocode

    # == Multi-Select Search ==
    scope :state_code, -> (state_code) { where state_code: state_code }
    scope :source, -> (source) { where source: source }
    scope :tier, -> (tier) { where tier: tier }
    scope :sales_person, -> (sales_person) { where sales_person: sales_person }
    scope :acct_type, -> (acct_type) { where acct_type: acct_type }
    scope :location_status, -> (location_status) { where location_status: location_status }

    # == Key Word Search ==
    scope :latitude, -> (latitude) { where("latitude like ?", "%#{latitude}%") }
    scope :longitude, -> (longitude) { where("longitude like ?", "%#{longitude}%") }
    scope :created_at, -> (created_at) { where("created_at like ?", "%#{created_at}%") }
    scope :updated_at, -> (updated_at) { where("updated_at like ?", "%#{updated_at}%") }
    scope :city, -> (city) { where("city like ?", "%#{city}%") }
    scope :postal_code, -> (postal_code) { where("postal_code like ?", "%#{postal_code}%") }
    scope :coordinates, -> (coordinates) { where("coordinates like ?", "%#{coordinates}%") }
    scope :acct_name, -> (acct_name) { where("acct_name like ?", "%#{acct_name}%") }
    scope :group_name, -> (group_name) { where("group_name like ?", "%#{group_name}%") }
    scope :ult_group_name, -> (ult_group_name) { where("ult_group_name like ?", "%#{ult_group_name}%") }
    scope :sfdc_id, -> (sfdc_id) { where("sfdc_id like ?", "%#{sfdc_id}%") }
    scope :url, -> (url) { where("url like ?", "%#{url}%") }
    scope :root, -> (root) { where("root like ?", "%#{root}%") }
    scope :franchise, -> (franchise) { where("franchise like ?", "%#{franchise}%") }
    scope :street, -> (street) { where("street like ?", "%#{street}%") }
    scope :address, -> (address) { where("address like ?", "%#{address}%") }
    scope :temporary_id, -> (temporary_id) { where("temporary_id like ?", "%#{temporary_id}%") }
    scope :geo_acct_name, -> (geo_acct_name) { where("geo_acct_name like ?", "%#{geo_acct_name}%") }
    scope :geo_full_addr, -> (geo_full_addr) { where("geo_full_addr like ?", "%#{geo_full_addr}%") }


# CSV#
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
          Location.create!(row_hash)
      end
  end

end
