class CreateTherapies < ActiveRecord::Migration
  def change
    create_table :therapies do |t|
      t.string :name
      t.integer :capacity
      t.integer :length_in_minutes
      t.integer :calendar_id

      t.timestamps null: false
    end
  end
end
