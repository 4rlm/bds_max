require 'csv'

class Gcse < ApplicationRecord
    include Filterable

    def self.to_csv
        CSV.generate do |csv|
          csv << column_names
          all.each do |gcse|
            csv << gcse.attributes.values_at(*column_names)
          end
        end
      end

    def self.import_csv(file_name)
        CSV.foreach(file_name.path, headers: true, skip_blanks: true) do |row|
            row_hash = row.to_hash

            # ========= CSV column formatting =========
            # Capitalize columns
            row_hash[:sfdc_ult_acct] = Gcse.capitalized(row_hash["sfdc_ult_acct"])
            row_hash[:sfdc_acct] = Gcse.capitalized(row_hash["sfdc_acct"])
            row_hash[:sfdc_type] = Gcse.capitalized(row_hash["sfdc_type"])
            row_hash[:sfdc_street] = Gcse.capitalized(row_hash["sfdc_street"])
            row_hash[:sfdc_city] = Gcse.capitalized(row_hash["sfdc_city"])
            row_hash[:domain_status] = Gcse.capitalized(row_hash["domain_status"])

            # Upcase column
            row_hash[:sfdc_state] = Gcse.upcased(row_hash["sfdc_state"])

            # Downcase columns
            row_hash[:sfdc_url_o] = Gcse.downcased(row_hash["sfdc_url_o"])
            row_hash[:domain] = Gcse.downcased(row_hash["domain"])
            row_hash[:root] = Gcse.downcased(row_hash["root"])
            row_hash[:suffix] = Gcse.downcased(row_hash["suffix"])
            row_hash[:in_host_pos] = Gcse.downcased(row_hash["in_host_pos"])
            row_hash[:exclude_root] = Gcse.downcased(row_hash["exclude_root"])
            row_hash[:text] = Gcse.downcased(row_hash["text"])
            row_hash[:in_text_pos] = Gcse.downcased(row_hash["in_text_pos"])
            row_hash[:in_text_del] = Gcse.downcased(row_hash["in_text_del"])
            row_hash[:sfdc_root] = Gcse.downcased(row_hash["sfdc_root"])
            # ========= Ends CSV column formatting =========

            Gcse.create!(row_hash)
        end
    end

    # Compare the sfdc urls and new urls, and the sfdc roots and new roots.
    def self.compare(arr1, arr2)
        results = []
        for i in 0...arr1.length
            if arr1[i] == arr2[i]
                results << "Same"
            else
                results << "Different"
            end
        end
        results
    end

    def self.solitarible?(root)
        terms = InHostPo.all.map(&:term)
        for term in terms
            return true if root.include?(term)
        end
        false
    end

    # ========= CSV column formatting =========
    # CSV column formatting=========
    def self.capitalized(str)
        str.split.map(&:capitalize)*" " unless str.nil?
    end

    def self.upcased(str)
        str.upcase unless str.nil?
    end

    def self.downcased(str)
        str.downcase unless str.nil?
    end
    # ========= Ends CSV column formatting =========

    # enum status: [:active, :pending, :inactive]
    # scope :status, -> (status) { where status: status }
    # scope :location, -> (location) { where("location like ?", "%#{location}%") }
    scope :domain_status, -> (domain_status) { where domain_status: domain_status }
    scope :gcse_timestamp, -> (gcse_timestamp) { where gcse_timestamp: gcse_timestamp }
    scope :gcse_query_num, -> (gcse_query_num) { where gcse_query_num: gcse_query_num }
    scope :gcse_result_num, -> (gcse_result_num) { where gcse_result_num: gcse_result_num }
    scope :sfdc_id, -> (sfdc_id) { where("sfdc_id like ?", "%#{sfdc_id}%") }
    scope :sfdc_ult_acct, -> (sfdc_ult_acct) { where sfdc_ult_acct: sfdc_ult_acct }
    scope :sfdc_acct, -> (sfdc_acct) { where sfdc_acct: sfdc_acct }
    scope :sfdc_type, -> (sfdc_type) { where sfdc_type: sfdc_type }
    scope :sfdc_street, -> (sfdc_street) { where("sfdc_street like ?", "%#{sfdc_street}%") }
    scope :sfdc_city, -> (sfdc_city) { where sfdc_city: sfdc_city }
    scope :sfdc_state, -> (sfdc_state) { where sfdc_state: sfdc_state }
    scope :sfdc_url_o, -> (sfdc_url_o) { where sfdc_url_o: sfdc_url_o }
    scope :sfdc_root, -> (sfdc_root) { where sfdc_root: sfdc_root }
    scope :root, -> (root) { where root: root }
    scope :domain, -> (domain) { where domain: domain }
    scope :root_counter, -> (root_counter) { where root_counter: root_counter }
    scope :suffix, -> (suffix) { where suffix: suffix }
    scope :in_host_pos, -> (in_host_pos) { where in_host_pos: in_host_pos }
    scope :exclude_root, -> (exclude_root) { where exclude_root: exclude_root }
    scope :text, -> (text) { where("text like ?", "%#{text}%") }
    scope :in_text_pos, -> (in_text_pos) { where in_text_pos: in_text_pos }
    scope :in_text_del, -> (in_text_del) { where in_text_del: in_text_del }

 end
