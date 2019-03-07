class AddIntervalToItems < ActiveRecord::Migration[5.2]
  def change
    add_column :items, :interval, :integer, default: 60 * 24
    add_column :items, :last_price_update, :datetime
  end
end
