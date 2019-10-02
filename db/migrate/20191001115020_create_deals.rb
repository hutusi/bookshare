class CreateDeals < ActiveRecord::Migration[6.0]
  def change
    create_table :deals do |t|
      t.string :type
      t.integer :print_book_id, null: false
      t.integer :book_id, null: false
      t.integer :sponsor_id, null: false
      t.integer :receiver_id
      t.string :location
      t.integer :status, default: 0
      t.datetime :started_at
      t.datetime :finished_at

      t.timestamps
    end

    add_index :deals, :print_book_id
    add_index :deals, :book_id
    add_index :deals, :sponsor_id
    add_index :deals, :receiver_id
  end
end
