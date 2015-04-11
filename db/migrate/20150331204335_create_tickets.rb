class CreateTickets < ActiveRecord::Migration
  def change
    create_table :tickets do |t|
      t.datetime :time_restriction
      t.integer :entries_remaining
      t.datetime :activated_on
      t.boolean :paid, default: true
      t.integer :user_id

      t.timestamps null: false
    end
  end
end
