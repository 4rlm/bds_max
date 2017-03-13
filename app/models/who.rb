require 'csv'

class Who < ApplicationRecord
    # FILTERABLE #
    include Filterable

    # == Multi-Select Search ==
    scope :who_status, -> (who_status) { where who_status: who_status }
    scope :url_status, -> (url_status) { where url_status: url_status }

    # == Key Word Search ==
    scope :domain, -> (domain) { where("domain like ?", "%#{domain}%") }
    scope :domain_id, -> (domain_id) { where("domain_id like ?", "%#{domain_id}%") }
    scope :ip, -> (ip) { where("ip like ?", "%#{ip}%") }
    scope :server1, -> (server1) { where("server1 like ?", "%#{server1}%") }
    scope :server2, -> (server2) { where("server2 like ?", "%#{server2}%") }
    scope :registrar_url, -> (registrar_url) { where("registrar_url like ?", "%#{registrar_url}%") }
    scope :registrant_name, -> (registrant_name) { where("registrant_name like ?", "%#{registrant_name}%") }

    scope :registrant_organization, -> (registrant_organization) { where("registrant_organization like ?", "%#{registrant_organization}%") }
    scope :registrant_address, -> (registrant_address) { where("registrant_address like ?", "%#{registrant_address}%") }
    scope :registrant_city, -> (registrant_city) { where("registrant_city like ?", "%#{registrant_city}%") }
    scope :registrant_zip, -> (registrant_zip) { where("registrant_zip like ?", "%#{registrant_zip}%") }
    scope :registrant_state, -> (registrant_state) { where("registrant_state like ?", "%#{registrant_state}%") }
    scope :registrant_phone, -> (registrant_phone) { where("registrant_phone like ?", "%#{registrant_phone}%") }
    scope :registrant_url, -> (registrant_url) { where("registrant_url like ?", "%#{registrant_url}%") }
    scope :who_addr_pin, -> (who_addr_pin) { where("who_addr_pin like ?", "%#{who_addr_pin}%") }



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
              Who.create!(row_hash)
          end
      end


end
