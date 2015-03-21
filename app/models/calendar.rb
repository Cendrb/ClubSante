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
end
