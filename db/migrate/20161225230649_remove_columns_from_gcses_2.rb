class RemoveColumnsFromGcses2 < ActiveRecord::Migration[5.0]
    def change
        remove_column :gcses, :sfdc_id, :string
        remove_column :gcses, :sfdc_ult_acct, :string
        remove_column :gcses, :sfdc_acct, :string
        remove_column :gcses, :sfdc_type, :string
        remove_column :gcses, :sfdc_street, :string
        remove_column :gcses, :sfdc_city, :string
        remove_column :gcses, :sfdc_state, :string
        remove_column :gcses, :sfdc_url_o, :string
        remove_column :gcses, :sfdc_root, :string
    end
end
