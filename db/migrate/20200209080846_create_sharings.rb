class CreateSharings < ActiveRecord::Migration[6.0]
  def change
    create_table :sharings do |t|
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

    add_index :sharings, :print_book_id
    add_index :sharings, :book_id
    add_index :sharings, :holder_id
    add_index :sharings, :receiver_id
  end
end
