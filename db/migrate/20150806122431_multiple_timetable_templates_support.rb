class MultipleTimetableTemplatesSupport < ActiveRecord::Migration
  def change
    add_column :timetable_templates, :beginning, :datetime
    rename_column :exercise_modifications, :timetable_template_id, :timetable_modification_id
    change_table :exercises do |t|
      t.references :registerable, polymorphic: true, index: true
    end
  end
end
