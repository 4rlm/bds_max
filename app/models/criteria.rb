class Criteria < ApplicationRecord

    require 'csv'
    def self.to_csv
        CSV.generate do |csv|
          csv << column_names
          all.each do |criteria|
            csv << criteria.attributes.values_at(*column_names)
          end
        end
      end

 end
