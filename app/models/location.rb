require 'csv'

class Location < ApplicationRecord

# FILTERABLE #
include Filterable

# MULTI-SELECT #
scope :location_status, -> (location_status) { where location_status: location_status }

# GEOCODE - GOOGLE #
  geocoded_by :address
  after_validation :geocode, :if => :address_changed?


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
