class TimetableTemplate < ActiveRecord::Base
  belongs_to :calendar
  has_many :weekday_templates, dependent: :destroy
  before_create :init_dependent
  
  def init_dependent
    for i in 0..6
     self.weekday_templates << WeekdayTemplate.create(weekday: i)
    end
     true
  end
end
