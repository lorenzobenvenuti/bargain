class CreateRules < ActiveRecord::Migration[5.2]
  def change
    create_table :rules do |t|
      t.string :rule_type
      t.string :rule_args
      t.belongs_to :scraper, foreign_key: true

      t.timestamps
    end
  end
end
