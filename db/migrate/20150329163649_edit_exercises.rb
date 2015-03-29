class EditExercises < ActiveRecord::Migration
  def change
    remove_column :exercises, :exercise_day_id
    add_column :exercises, :timetable_id, :integer
  end
end
