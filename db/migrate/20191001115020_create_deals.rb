class CreateDeals < ActiveRecord::Migration[6.0]
  def change
    create_table :deals do |t|
      t.string :type
      t.integer :print_book_id
      t.integer :book_id
      t.integer :sponsor_id
      t.integer :receiver_id
      t.string :location
      t.string :status
      t.datetime :started_at
      t.datetime :finished_at

      t.timestamps
    end
  end
end
