class CreatePrintBooks < ActiveRecord::Migration[6.0]
  def change
    create_table :print_books do |t|
      t.integer :book_id, null: false
      t.integer :owner_id, null: false
      t.integer :holder_id, null: false
      t.string :property
      t.string :status
      t.text :images
      t.text :description
      t.integer :created_by, null: false

      t.timestamps
    end

    add_index :print_books, :book_id
    add_index :print_books, :owner_id
    add_index :print_books, :holder_id
    add_index :print_books, :created_by
  end
end
