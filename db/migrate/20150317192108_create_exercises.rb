class CreateExercises < ActiveRecord::Migration
  def change
    create_table :exercises do |t|
      t.time :beginning
      t.belongs_to :exercise_day

      t.timestamps null: false
    end
  end
end
