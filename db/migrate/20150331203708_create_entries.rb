class CreateEntries < ActiveRecord::Migration
  def change
    create_table :entries do |t|
      t.integer :exercise_id
      t.integer :ticket_id
      t.integer :user_id
      t.string :message

      t.timestamps null: false
    end
  end
end
