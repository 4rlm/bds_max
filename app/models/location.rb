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
    scope :rev_state_code, -> (rev_state_code) { where rev_state_code: rev_state_code }

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
    scope :rev_full_address, -> (rev_full_address) { where("rev_full_address like ?", "%#{rev_full_address}%") }
    scope :rev_street, -> (rev_street) { where("rev_street like ?", "%#{rev_street}%") }
    scope :rev_city, -> (rev_city) { where("rev_city like ?", "%#{rev_city}%") }
    scope :rev_state, -> (rev_state) { where("rev_state like ?", "%#{rev_state}%") }
    scope :rev_postal_code, -> (rev_postal_code) { where("rev_postal_code like ?", "%#{rev_postal_code}%") }
    scope :url, -> (url) { where("url like ?", "%#{url}%") }
    scope :root, -> (root) { where("root like ?", "%#{root}%") }
    scope :franchise, -> (franchise) { where("franchise like ?", "%#{franchise}%") }
    scope :street, -> (street) { where("street like ?", "%#{street}%") }
    scope :address, -> (address) { where("address like ?", "%#{address}%") }

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
