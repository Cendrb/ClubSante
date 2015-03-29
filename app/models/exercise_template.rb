class ExerciseTemplate < ActiveRecord::Base
  validates_presence_of :beginning, :timetable_template_id
  belongs_to :timetable_template
end
