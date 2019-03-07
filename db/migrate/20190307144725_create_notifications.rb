class CreateNotifications < ActiveRecord::Migration[5.2]
  def change
    create_table :notifications do |t|
      t.string :notification_type
      t.string :notification_args
      t.float :threshold
      t.belongs_to :item, foreign_key: true

      t.timestamps
    end
  end
end
