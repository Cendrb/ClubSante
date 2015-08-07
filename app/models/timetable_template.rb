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
