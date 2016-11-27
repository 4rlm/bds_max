class CreateInSuffixDels < ActiveRecord::Migration[5.0]
  def change
    create_table :in_suffix_dels do |t|
      t.string :term

      t.timestamps
    end
  end
end
