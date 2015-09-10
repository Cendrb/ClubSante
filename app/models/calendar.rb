class Calendar < ActiveRecord::Base
  belongs_to :therapy
  has_one :timetable, dependent: :destroy
  has_many :timetable_templates, dependent: :destroy
  has_one :timetable_modification, dependent: :destroy

  before_create :init_dependent

  def init_dependent
    self.timetable = Timetable.create!
    self.timetable_modification = TimetableModification.create!
    self.timetable_templates << TimetableTemplate.create!(beginning: Time.new(2001))
    true
  end

  def self.pixels_per_minute
    return 0.8
  end

  def self.min_max_hour_for(exercise_templates, exercise_modifications)
    min_modification_hour = 24
    if(exercise_modifications.count > 0)
      min_modification_hour = exercise_modifications.minimum(:date).hour
    end
    min_template_hour = 24
    if (exercise_templates.count > 0)
      min_template_hour = exercise_templates.minimum(:beginning).hour
    end
    min_hour = [min_modification_hour, min_template_hour].min

    max_modification_hour = 0
    if(exercise_modifications.count > 0)
      max_modification_hour = exercise_modifications.maximum(:date).hour + 1
    end
    max_template_hour = 0
    if (exercise_templates.count > 0)
      max_template_hour = exercise_templates.maximum(:beginning).hour + 1
    end
    max_hour = [max_modification_hour, max_template_hour].max

    if(min_hour > max_hour)
      min_hour = 0
      max_hour = 0
    end
    return min_hour, max_hour
  end
end
