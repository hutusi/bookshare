class CreateBooks < ActiveRecord::Migration[6.0]
  def change
    create_table :books do |t|
      t.string :title, null: false
      t.string :subtitle
      t.string :author
      t.string :publisher
      t.text :intro
      t.string :isbn, null: false
      t.string :cover_url
      t.string :douban_id
      t.integer :created_by

      t.timestamps
    end

    add_index :books, :created_by
  end
end
