class AddAvailableToExercises < ActiveRecord::Migration
  def change
    add_column :exercises, :available, :boolean, :default => true
  end
end
