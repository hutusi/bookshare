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
      t.integer :creator_id, null: false

      t.timestamps
    end

    add_index :books, :isbn, unique: true
    add_index :books, :creator_id
  end
end
