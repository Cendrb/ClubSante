class CreateTrackedValues < ActiveRecord::Migration
  def change
    create_table :tracked_values do |t|
      t.integer :user_id
      t.integer :available_value_id

      t.timestamps null: false
    end
  end
end
