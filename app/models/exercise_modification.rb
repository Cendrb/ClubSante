class ExerciseModification < ActiveRecord::Base
  belongs_to :timetable_template
  belongs_to :coach
  has_one :therapy, through: [:timetable_template, :calendar, :therapy]
end
