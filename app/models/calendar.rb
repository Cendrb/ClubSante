class Calendar < ActiveRecord::Base
  belongs_to :therapy
  has_one :timetable, dependent: :destroy
  has_one :timetable_template, dependent: :destroy
  
  before_create :init_dependent
  
  def init_dependent
    puts "1"
     self.timetable = Timetable.create
     puts "2"
     self.timetable_template = TimetableTemplate.create
     puts "3"
     true
  end
  
  def self.pixels_per_minute
    return 1
  end
  
  def self.min_hour_for(exercises, exercise_templates)
    if(exercises.minimum("EXTRACT(HOUR FROM date)").nil?)
      registered_min_hour = 69
    else
      registered_min_hour = exercises.minimum("EXTRACT(HOUR FROM date)").round
    end
    
    return [registered_min_hour, exercise_templates.minimum(:beginning).hour].min
    
  end
  
  def self.max_hour_for(exercises, exercise_templates)
    if(exercises.maximum("EXTRACT(HOUR FROM date)").nil?)
      registered_max_hour = -69
    else
      registered_max_hour = exercises.minimum("EXTRACT(HOUR FROM date)").round
    end
    
    return [registered_max_hour, exercise_templates.maximum(:beginning).hour].max + 1
  end
end
