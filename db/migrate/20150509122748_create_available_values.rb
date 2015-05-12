class CreateAvailableValues < ActiveRecord::Migration
  def change
    create_table :available_values do |t|
      t.string :name

      t.timestamps null: false
    end
  end
end
