class Gcse < ApplicationRecord


    def self.to_csv
        CSV.generate do |csv|
          csv << column_names
          all.each do |gcse|
            csv << gcse.attributes.values_at(*column_names)
          end
        end
      end

    require 'csv'
    def self.import_csv(file_name)
        CSV.foreach(file_name.path, headers: true, skip_blanks: true) do |row|
            row_hash = row.to_hash
            Gcse.create!(row_hash)
        end
    end

    include Filterable
    # enum status: [:active, :pending, :inactive]
    # scope :status, -> (status) { where status: status }
    # scope :location, -> (location) { where("location like ?", "%#{location}%") }
    scope :domain_status, -> (domain_status) { where domain_status: domain_status }
    scope :gcse_timestamp, -> (gcse_timestamp) { where gcse_timestamp: gcse_timestamp }
    scope :gcse_query_num, -> (gcse_query_num) { where gcse_query_num: gcse_query_num }
    scope :gcse_result_num, -> (gcse_result_num) { where gcse_result_num: gcse_result_num }
    scope :sfdc_id, -> (sfdc_id) { where sfdc_id: sfdc_id }
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
    scope :in_host_neg, -> (in_host_neg) { where in_host_neg: in_host_neg }
    scope :in_host_del, -> (in_host_del) { where in_host_del: in_host_del }
    scope :in_suffix_del, -> (in_suffix_del) { where in_suffix_del: in_suffix_del }
    scope :exclude_root, -> (exclude_root) { where exclude_root: exclude_root }
    scope :text, -> (text) { where("text like ?", "%#{text}%") }
    scope :in_text_pos, -> (in_text_pos) { where in_text_pos: in_text_pos }
    scope :in_text_neg, -> (in_text_neg) { where in_text_neg: in_text_neg }
    scope :in_text_del, -> (in_text_del) { where in_text_del: in_text_del }
    scope :url_encoded, -> (url_encoded) { where url_encoded: url_encoded }

 end
