class AddColumnToWhos4 < ActiveRecord::Migration[5.1]
  def change
    add_column :whos, :whois_date, :datetime
  end
end
