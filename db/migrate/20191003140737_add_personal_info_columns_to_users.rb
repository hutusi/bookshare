class AddPersonalInfoColumnsToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :username, :string
    
    # wechat info
    add_column :users, :nickname, :string
    add_column :users, :avatar, :string
    add_column :users, :gender, :integer
    add_column :users, :country, :string
    add_column :users, :province, :string
    add_column :users, :city, :string
    add_column :users, :language, :integer

    add_column :users, :phone, :string
    add_column :users, :company, :string
    add_column :users, :bio, :text
    add_column :users, :contact, :string
    add_column :users, :birthdate, :datetime

    add_index :users, :username, unique: true
  end
end
