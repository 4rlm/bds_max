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

    scope :admin_name, -> (admin_name) { where("admin_name like ?", "%#{admin_name}%") }
    scope :admin_organization, -> (admin_organization) { where("admin_organization like ?", "%#{admin_organization}%") }
    scope :admin_address, -> (admin_address) { where("admin_address like ?", "%#{admin_address}%") }
    scope :admin_city, -> (admin_city) { where("admin_city like ?", "%#{admin_city}%") }
    scope :admin_zip, -> (admin_zip) { where("admin_zip like ?", "%#{admin_zip}%") }
    scope :admin_state, -> (admin_state) { where("admin_state like ?", "%#{admin_state}%") }
    scope :admin_phone, -> (admin_phone) { where("admin_phone like ?", "%#{admin_phone}%") }
    scope :admin_url, -> (admin_url) { where("admin_url like ?", "%#{admin_url}%") }
    scope :tech_name, -> (tech_name) { where("tech_name like ?", "%#{tech_name}%") }
    scope :tech_organization, -> (tech_organization) { where("tech_organization like ?", "%#{tech_organization}%") }
    scope :tech_address, -> (tech_address) { where("tech_address like ?", "%#{tech_address}%") }
    scope :tech_city, -> (tech_city) { where("tech_city like ?", "%#{tech_city}%") }
    scope :tech_zip, -> (tech_zip) { where("tech_zip like ?", "%#{tech_zip}%") }
    scope :tech_state, -> (tech_state) { where("tech_state like ?", "%#{tech_state}%") }
    scope :tech_phone, -> (tech_phone) { where("tech_phone like ?", "%#{tech_phone}%") }
    scope :tech_url, -> (tech_url) { where("tech_url like ?", "%#{tech_url}%") }
    scope :registrant_pin, -> (registrant_pin) { where("registrant_pin like ?", "%#{registrant_pin}%") }
    scope :tech_pin, -> (tech_pin) { where("tech_pin like ?", "%#{tech_pin}%") }
    scope :admin_pin, -> (admin_pin) { where("admin_pin like ?", "%#{admin_pin}%") }


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
