class ExerciseModification < ActiveRecord::Base
  validates_presence_of :date, :coach_id, :price, :timetable_modification_id
  validates_inclusion_of :removal, in: [true, false]
  
  belongs_to :timetable_modification
  belongs_to :coach
  belongs_to :exercise_template
  has_one :exercise, dependent: :destroy
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
      return "odstraněná hodina (#{date.to_s(:time)})"
    end
    if(removal == false && !exercise_template)
      return "přidaná hodina (#{date.to_s(:time)})"
    end
    if(removal == false && exercise_template && differs_from_template)
      string = []
      date.to_s(:time) != exercise_template.beginning.to_s(:time) ? (string << "přesunuto z #{exercise_template.beginning.to_s(:time)} na #{date.to_s(:time)}") : ""
      coach != exercise_template.coach ? (string << "trenér změněn z #{exercise_template.coach.name} na #{coach.name}") : ""
      price != exercise_template.price ? (string << "cena změněna z #{exercise_template.price} na #{price}") : ""
      string = string.join("\n")
      return string
    end
    return "nic nemění"
  end
  
  def differs_from_template
    if(exercise_template)
      return date.to_s(:time) != exercise_template.beginning.to_s(:time) || coach != exercise_template.coach || price != exercise_template.price
    else
      return true
    end
  end
end
