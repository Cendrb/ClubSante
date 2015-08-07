class ExerciseTemplate < ActiveRecord::Base
  validates_presence_of :beginning, :timetable_template_id
  belongs_to :timetable_template
  belongs_to :coach
  has_one :exercise_modification
  has_one :therapy, through: [:timetable_template, :calendar]
  has_one :calendar, through: :timetable_template
  
  def get_tooltip_calendar
    string = "TEMPLATE<br />#{get_time_range_string}<br />#{get_duration_string}<br />#{get_capacity_string}"
    if(price != ExerciseTemplate.get_hide_string)
      string += "<br />#{price}"
    end
    if(coach && coach != Coach.get_nobody)
      string += "<br />#{coach.name}"
    end
    return string
  end
  
  def get_tooltip_template
    string = "Cena: #{self.price}<br />Trenér: #{self.coach.name}"
    return string
  end
  
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
  
  def get_coach_string
    if(coach)
      puts coach.name
      return "#{coach.name}"
    end
  end
  
  
  def self.get_hide_string
    return "Nezobrazovat"
  end
  
  def self.get_the_same_string
    return "< ponechat >"
  end
end
