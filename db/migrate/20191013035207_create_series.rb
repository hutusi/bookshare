class CreateSeries < ActiveRecord::Migration[6.0]
  def change
    create_table :series do |t|
      t.string :name
      t.string :douban_id
      t.text :intro

      t.timestamps
    end

    add_index :series, :douban_id
  end
end
