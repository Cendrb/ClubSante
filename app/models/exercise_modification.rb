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
  
  
  def get_tooltip_calendar
    string = "MODIFICATION<br />#{get_time_range_string}<br />#{get_duration_string}<br />#{get_capacity_string}"
    if(price != ExerciseTemplate.get_hide_string)
      string += "<br />#{price}"
    end
    if(coach && coach != Coach.get_nobody)
      string += "<br />#{coach.name}"
    end
    return string
  end
  
  def get_tooltip_modification
    string = "Cena: #{self.price}<br />Trenér: #{self.coach.name}"
    return string
  end
  
  def get_capacity_string
    return "obsazeno 0 z #{self.timetable_modification.calendar.therapy.capacity}"
  end
  
  def get_beginning_string
    return self.date.to_s(:time)
  end
  
  def get_time_range_string
    return "#{get_beginning_string} - #{(self.date + self.timetable_modification.calendar.therapy.duration_in_minutes.minutes).to_s(:time)}"
  end
  
  def get_duration_string
    return "#{self.timetable_modification.calendar.therapy.duration_in_minutes} minut"
  end
  
  def get_coach_string
    if(coach)
      puts coach.name
      return "#{coach.name}"
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
