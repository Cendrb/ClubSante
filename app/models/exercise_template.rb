class ExerciseTemplate < ActiveRecord::Base
  validates_presence_of :beginning, :timetable_template_id
  belongs_to :timetable_template
  belongs_to :coach
  has_many :exercise_modifications
  has_one :therapy, through: [:timetable_template, :calendar]
  has_one :calendar, through: :timetable_template
  
  def self.get_hide_string
    return "Nezobrazovat"
  end
  
  def self.get_the_same_string
    return "< ponechat >"
  end
end
