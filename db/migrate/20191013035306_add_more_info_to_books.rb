class AddMoreInfoToBooks < ActiveRecord::Migration[6.0]
  def change
    remove_column :books, :author
    remove_column :books, :publisher

    add_column :books, :data_source, :integer

    add_column :books, :isbn10, :string
    add_column :books, :isbn13, :string
    add_column :books, :origin_title, :string
    add_column :books, :alt_title, :string
    add_column :books, :image, :string
    add_column :books, :images, :json
    add_column :books, :author_id, :integer
    add_column :books, :author_name, :string
    add_column :books, :translator_id, :integer
    add_column :books, :translator_name, :string
    add_column :books, :publisher_id, :integer
    add_column :books, :publisher_name, :string
    add_column :books, :pubdate, :datetime
    add_column :books, :rating, :json
    add_column :books, :binding, :string
    add_column :books, :price, :string
    add_column :books, :series_id, :integer
    add_column :books, :series_name, :string
    add_column :books, :pages, :string
    add_column :books, :summary, :string
    add_column :books, :catalog, :string

    add_foreign_key :books, :litterateurs, column: :author_id
    add_foreign_key :books, :litterateurs, column: :translator_id
    add_foreign_key :books, :publishers, column: :publisher_id
    add_foreign_key :books, :series, column: :series_id
  end
end
