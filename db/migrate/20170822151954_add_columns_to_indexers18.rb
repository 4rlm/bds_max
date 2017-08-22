class AddColumnsToIndexers18 < ActiveRecord::Migration[5.1]
  def change
    add_column :indexers, :account_scrape_date, :datetime
  end
end
