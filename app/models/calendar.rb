class Calendar < ActiveRecord::Base
  validates_presence_of :timetable_templates
  belongs_to :therapy
  has_one :timetable, dependent: :destroy
  has_many :timetable_templates, dependent: :destroy
  has_one :timetable_modification, dependent: :destroy
  
  before_create :init_dependent
  
  def init_dependent
     self.timetable = Timetable.create
     self.timetable_modification = TimetableModification.create
     self.timetable_templates << TimetableTemplate.create(beginning: Time.new(2001))
     true
  end
  
  def self.pixels_per_minute
    return 0.4
  end
  
  def self.min_hour_for(exercises, exercise_templates)
    if(exercises.joins(:exercise_modification).minimum("EXTRACT(HOUR FROM exercise_modifications.date)").nil?)
      registered_min_modification_hour = 69
    else
      registered_min_modification_hour = exercises.joins(:exercise_modification).minimum("EXTRACT(HOUR FROM exercise_modifications.date)").round
    end
    puts "MIN: #{registered_min_modification_hour}"

    if(exercise_templates.count > 0)
      return [registered_min_modification_hour, exercise_templates.minimum(:beginning).hour].min
    else
      return 0
    end
    
  end
  
  def self.max_hour_for(exercises, exercise_templates)
    if(exercises.joins(:exercise_modification).maximum("EXTRACT(HOUR FROM exercise_modifications.date)").nil?)
      registered_max_modification_hour = -69
    else
      registered_max_modification_hour = exercises.joins(:exercise_modification).maximum("EXTRACT(HOUR FROM exercise_modifications.date)").round
    end
    puts "MAX: #{registered_max_modification_hour}"
    
    return [registered_max_modification_hour, exercise_templates.maximum(:beginning).hour].max + 1
  end
end
