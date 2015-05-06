class ExerciseTemplate < ActiveRecord::Base
  validates_presence_of :beginning, :timetable_template_id
  belongs_to :timetable_template
  
  has_one :therapy, through: [:timetable_template, :calendar, :therapy]
  
  def get_capacity_string
    return "obsazeno 0 z #{self.timetable_template.calendar.therapy.capacity}"
  end
  
  def get_beginning_string
    return self.beginning.to_s(:time)
  end
  
  def get_time_range_string
    return "#{get_beginning_string} - #{(self.beginning + self.timetable_template.calendar.therapy.duration_in_minutes.minutes).to_s(:time)}"
  end
  
  def get_duration_string
    return "#{self.timetable_template.calendar.therapy.duration_in_minutes} minut"
  end
end
