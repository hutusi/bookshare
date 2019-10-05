class AddForeignKeysToTables < ActiveRecord::Migration[6.0]
  def change
    add_foreign_key :books, :users, column: :creator_id

    add_foreign_key :print_books, :books
    add_foreign_key :print_books, :users, column: :owner_id
    add_foreign_key :print_books, :users, column: :holder_id
    add_foreign_key :print_books, :users, column: :creator_id

    add_foreign_key :deals, :print_books
    add_foreign_key :deals, :books
    add_foreign_key :deals, :users, column: :sponsor_id
    add_foreign_key :deals, :users, column: :receiver_id
    add_foreign_key :deals, :users, column: :applicant_id
  end
end
