class CreateGoals < ActiveRecord::Migration
  def change
    create_table :goals do |t|
      t.integer :tracked_value_id
      t.float :value
      t.date :date

      t.timestamps null: false
    end
  end
end
