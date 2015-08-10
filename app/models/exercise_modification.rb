class ExerciseModification < ActiveRecord::Base
  validates_presence_of :date, :coach_id, :price, :timetable_modification_id
  validates_inclusion_of :removal, in: [true, false]
  
  belongs_to :timetable_modification
  belongs_to :coach
  belongs_to :exercise_template
  has_one :exercise
  has_one :therapy, through: [:timetable_template, :calendar, :therapy]
  
  before_validation :load_default_values
  
  def load_default_values
    load_default_values_from(self.exercise_template)
  end
  
  def load_default_values_from(exercise_template)
    self.coach_id ||= exercise_template.coach_id
    self.price ||= exercise_template.price
  end
 
  def get_string
    if(removal && exercise_template)
      return "odstraněná hodina (#{date.strftime("%H:%M")})"
    end
    if(removal == false && !exercise_template)
      return "přidaná hodina (#{date.strftime("%H:%M")})"
    end
    if(removal == false && exercise_template)
      return "přesunutá hodina ze #{date.strftime("%H:%M")} na #{exercise_template.beginning.strftime("%H:%M")}"
    end
  end
  
  def differs_from_template
    if(exercise_template)
      return date.to_time != exercise_template.beginning || coach != exercise_template.coach || price != exercise_template.price
    else
      return true
    end
  end
end
