class CreateAddresses < ActiveRecord::Migration[5.1]
  def change
    create_table :addresses do |t|
      t.string :full_addr
      t.string :street
      t.string :city
      t.string :state
      t.string :zip
      t.string :addr_pin

      t.timestamps
    end
  end
end
