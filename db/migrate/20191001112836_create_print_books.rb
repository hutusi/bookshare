class CreatePrintBooks < ActiveRecord::Migration[6.0]
  def change
    create_table :print_books do |t|
      t.integer :book_id
      t.integer :owner_id
      t.integer :holder_id
      t.string :property
      t.string :status
      t.text :images
      t.text :description
      t.integer :created_by

      t.timestamps
    end
  end
end
