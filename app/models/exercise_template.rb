class ExerciseTemplate < ActiveRecord::Base
  validates_presence_of :beginning, :weekday_template_id
  belongs_to :weekday_template
end
