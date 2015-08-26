class AtLeastOneTimetableTemplate < ActiveModel::Validator
  def validate(record)
    if(record.calendar.timetable_templates.where('beginning < ?', Date.today).count <= 1 && TimetableTemplate.find(record.id).beginning < Date.today && record.beginning >= Date.today)
      record.errors[:beginning] << 'Minimálně jeden týdenní plán musí být aktuálně aktivní'
    end
  end
end

class TimetableTemplate < ActiveRecord::Base
  validates_presence_of :beginning
  belongs_to :calendar
  has_many :exercise_templates, dependent: :destroy

  def self.pixels_per_minute
    return 1
  end
  
  def self.min_diff_time
    return 5
  end
end
