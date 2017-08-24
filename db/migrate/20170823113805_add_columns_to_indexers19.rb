class AddColumnsToIndexers19 < ActiveRecord::Migration[5.1]
  def change
    add_column :indexers, :page_finder_date, :datetime
  end
end
