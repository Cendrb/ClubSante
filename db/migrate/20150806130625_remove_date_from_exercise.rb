class RemoveDateFromExercise < ActiveRecord::Migration
  def change
    remove_column :exercises, :date
  end
end
