class CreateHosts < ActiveRecord::Migration[5.2]
  def change
    create_table :hosts do |t|
      t.string :host
      t.belongs_to :scraper, foreign_key: true

      t.timestamps
    end
  end
end
