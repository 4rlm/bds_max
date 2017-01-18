require 'csv'

class Location < ApplicationRecord

# FILTERABLE #
include Filterable

# MULTI-SELECT #
scope :location_status, -> (location_status) { where location_status: location_status }

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
