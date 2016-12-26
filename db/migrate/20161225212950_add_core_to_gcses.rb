class AddCoreToGcses < ActiveRecord::Migration[5.0]
  def change
    add_column :gcses, :core_id, :integer
    add_index :gcses, :core_id
  end
end
