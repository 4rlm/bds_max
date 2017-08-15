class AddColumnsToIndexers15 < ActiveRecord::Migration[5.1]
  def change
    add_column :indexers, :url_redirect_date, :datetime
  end
end
