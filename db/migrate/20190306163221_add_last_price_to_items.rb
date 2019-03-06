class AddLastPriceToItems < ActiveRecord::Migration[5.2]
  def change
    add_column :items, :last_price, :float
  end
end
