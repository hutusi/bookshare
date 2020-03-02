class DropTableDeals < ActiveRecord::Migration[6.0]
  def change
    drop_table :deals
  end
end
