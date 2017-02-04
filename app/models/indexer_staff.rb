require 'csv'

class IndexerStaff < ApplicationRecord
    include Filterable

    # == Multi-Select Search ==
    scope :indexer_status, -> (indexer_status) { where indexer_status: indexer_status }

    # == Key Word Search ==
    scope :sfdc_acct, -> (sfdc_acct) { where("sfdc_acct like ?", "%#{sfdc_acct}%") }
    scope :sfdc_group_name, -> (sfdc_group_name) { where("sfdc_group_name like ?", "%#{sfdc_group_name}%") }
    scope :sfdc_ult_acct, -> (sfdc_ult_acct) { where("sfdc_ult_acct like ?", "%#{sfdc_ult_acct}%") }
    scope :domain, -> (domain) { where("domain like ?", "%#{domain}%") }
    scope :ip, -> (ip) { where("ip like ?", "%#{ip}%") }
    scope :text, -> (text) { where("text like ?", "%#{text}%") }
    scope :href, -> (href) { where("href like ?", "%#{href}%") }
    scope :link, -> (link) { where("link like ?", "%#{link}%") }
    scope :sfdc_id, -> (sfdc_id) { where("sfdc_id like ?", "%#{sfdc_id}%") }


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
              IndexerStaff.create!(row_hash)
          end
      end

end
