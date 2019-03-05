class CreateScrapers < ActiveRecord::Migration[5.2]
  def change
    create_table :scrapers do |t|
      t.string :name
      t.string :price_selector
      t.string :price_regex

      t.timestamps
    end
  end
end
