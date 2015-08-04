class CreateExerciseModifications < ActiveRecord::Migration
  def change
    create_table :exercise_modifications do |t|
      t.integer :exercise_template_id
      t.datetime :date
      t.integer :coach_id
      t.string :price
      t.text :note
      t.integer :timetable_template_id

      t.timestamps null: false
    end
  end
end
