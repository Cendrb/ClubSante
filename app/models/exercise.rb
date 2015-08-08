class Exercise < ActiveRecord::Base
  validates_presence_of :timetable_id, :exercise_modification_id
  validates_uniqueness_of :exercise_modification_id
  belongs_to :timetable
  
  belongs_to :exercise_modification
  
  has_many :entries, dependent: :destroy
  
  has_one :therapy, through: [:timetable_template, :calendar, :therapy]
  
  
  scope :between, ->(first, second) { joins(:exercise_modification).where('exercise_modifications.date' => first..second) }
  scope :in_future, ->() { joins(:exercise_modification).where("exercise_modifications.date >= :today", today: Date.today) }
  
  def get_tooltip_calendar
    string = "FINAL EXERCISE<br />#{get_time_range_string}<br />#{get_duration_string}<br />#{get_capacity_string}"
    if(exercise_modification.price != ExerciseTemplate.get_hide_string)
      string += "<br />#{exercise_modification.price}"
    end
    if(exercise_modification.coach && exercise_modification.coach != Coach.get_nobody)
      string += "<br />#{exercise_modification.coach.name}"
    end
    return string
  end
  
  def full?
    return self.timetable.calendar.therapy.capacity <= self.entries.count
  end
  
  def signed_up?(user)
    return self.entries.joins(:ticket).where(tickets: { user_id: user.id }).count > 0
  end
  
  def get_capacity_string
    return "obsazeno #{self.entries.count} z #{self.timetable.calendar.therapy.capacity}"
  end
  
  def get_beginning_string
    return self.exercise_modification.date.to_s(:time)
  end
  
  def get_time_range_string
    return "#{get_beginning_string} - #{(self.exercise_modification.date + self.timetable.calendar.therapy.duration_in_minutes.minutes).to_s(:time)}"
  end
  
  def get_duration_string
    return "#{self.timetable.calendar.therapy.duration_in_minutes} minut"
  end
end
