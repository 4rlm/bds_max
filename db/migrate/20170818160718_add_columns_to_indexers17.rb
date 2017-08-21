class AddColumnsToIndexers17 < ActiveRecord::Migration[5.1]
  def change
    add_column :indexers, :template_status, :string
  end
end
