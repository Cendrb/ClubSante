class CreateExerciseTemplates < ActiveRecord::Migration
  def change
    create_table :exercise_templates do |t|
      t.string :weekday_template_id
      t.time :beginning

      t.timestamps null: false
    end
  end
end
