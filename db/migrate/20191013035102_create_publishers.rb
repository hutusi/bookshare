class CreatePublishers < ActiveRecord::Migration[6.0]
  def change
    create_table :publishers do |t|
      t.string :name
      t.string :country
      t.datetime :establish_date
      t.datetime :close_date
      t.text :intro

      t.timestamps
    end
  end
end
