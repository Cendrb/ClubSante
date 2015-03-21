class CreateExerciseDays < ActiveRecord::Migration
  def change
    create_table :exercise_days do |t|
      t.date :date
      t.belongs_to :timetable

      t.timestamps null: false
    end
  end
end
