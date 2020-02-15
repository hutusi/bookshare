class CreateBorrowings < ActiveRecord::Migration[6.0]
  def change
    create_table :borrowings do |t|
      t.integer :print_book_id, null: false
      t.integer :book_id, null: false
      t.integer :holder_id, null: false
      t.integer :receiver_id, null: false
      t.integer :form, default: 0
      t.integer :status, default: 0
      t.datetime :started_at
      t.datetime :finished_at
      t.text :application_reason
      t.text :application_reply

      t.timestamps
    end

    add_index :borrowings, :print_book_id
    add_index :borrowings, :book_id
    add_index :borrowings, :holder_id
    add_index :borrowings, :receiver_id
  end
end
