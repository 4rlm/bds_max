class AddColumnsToIndexers16 < ActiveRecord::Migration[5.1]
  def change
    add_column :indexers, :template_date, :datetime
  end
end
