class CreateBooks < ActiveRecord::Migration[6.0]
  def change
    create_table :books do |t|
      t.string :title
      t.string :subtitle
      t.string :author
      t.string :publisher
      t.text :intro
      t.string :isbn
      t.string :cover_url
      t.string :douban_id
      t.integer :created_by

      t.timestamps
    end
  end
end
