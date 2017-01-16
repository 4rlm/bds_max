
class Location < ApplicationRecord
  geocoded_by :address
  after_validation :geocode, :if => :address_changed?


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


# class Location < ApplicationRecord
#   geocoded_by :address do |obj,results|
#       if geo = results.first
#         location.city = geo.city
#         location.zipcode = geo.postal_code
#         location.country = geo.country_code
#       end
#     end
#
#   after_validation :geocode, :if => :address_changed?
# end




# == ORIGINAL ==
# class Location < ApplicationRecord
#   geocoded_by :address
#   after_validation :geocode, :if => :address_changed?
# end
