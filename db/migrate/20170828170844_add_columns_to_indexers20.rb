class AddColumnsToIndexers20 < ActiveRecord::Migration[5.1]
  def change
    add_column :indexers, :whois_date, :datetime
  end
end
