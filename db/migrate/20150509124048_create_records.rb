class CreateRecords < ActiveRecord::Migration
  def change
    create_table :records do |t|
      t.integer :tracked_value_id
      t.float :value
      t.date :date

      t.timestamps null: false
    end
  end
end
