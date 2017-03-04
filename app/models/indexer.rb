require 'csv'

class Indexer < ApplicationRecord

    # FILTERABLE #
    include Filterable

    # == Multi-Select Search ==
    scope :indexer_status, -> (indexer_status) { where indexer_status: indexer_status }
    scope :redirect_status, -> (redirect_status) { where redirect_status: redirect_status }
    scope :loc_status, -> (loc_status) { where loc_status: loc_status }
    scope :stf_status, -> (stf_status) { where stf_status: stf_status }
    scope :template, -> (template) { where template: template }



    # == Key Word Search ==
    scope :raw_url, -> (raw_url) { where("raw_url like ?", "%#{raw_url}%") }
    scope :clean_url, -> (clean_url) { where("clean_url like ?", "%#{clean_url}%") }
    scope :staff_url, -> (staff_url) { where("staff_url like ?", "%#{staff_url}%") }
    scope :staff_text, -> (staff_text) { where("staff_text like ?", "%#{staff_text}%") }
    scope :location_url, -> (location_url) { where("location_url like ?", "%#{location_url}%") }
    scope :location_text, -> (location_text) { where("location_text like ?", "%#{location_text}%") }



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
              Indexer.create!(row_hash)
          end
      end



end
