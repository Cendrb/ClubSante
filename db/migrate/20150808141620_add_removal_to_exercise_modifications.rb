class AddRemovalToExerciseModifications < ActiveRecord::Migration
  def change
    add_column :exercise_modifications, :removal, :boolean
  end
end
