class CreateLitterateurs < ActiveRecord::Migration[6.0]
  def change
    create_table :litterateurs do |t|
      t.string :name
      t.string :country
      t.integer :gender
      t.string :image
      t.datetime :birthdate
      t.datetime :deathdate
      t.text :bio
      t.text :intro
      t.string :origin_name
      t.string :pen_name

      t.timestamps
    end
  end
end
