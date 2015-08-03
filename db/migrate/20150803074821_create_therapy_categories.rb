class CreateTherapyCategories < ActiveRecord::Migration
  def change
    create_table :therapy_categories do |t|
      t.string :name

      t.timestamps null: false
    end
  end
end
