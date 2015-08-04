class AddPriceAndCoach < ActiveRecord::Migration
  def change
    add_column :exercise_templates, :price, :string
    add_column :exercise_templates, :coach_id, :integer
    add_column :exercise_templates, :note, :text
  end
end
