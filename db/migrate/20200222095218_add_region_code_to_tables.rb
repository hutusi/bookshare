class AddRegionCodeToTables < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :region_code, :integer

    add_column :print_books, :region_code, :integer
    add_index :print_books, :region_code

    add_column :sharings, :region_code, :integer
    add_column :borrowings, :region_code, :integer
  end
end
