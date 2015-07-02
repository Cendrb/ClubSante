class TimetableTemplate < ActiveRecord::Base
  belongs_to :calendar
  has_many :exercise_templates, dependent: :destroy
  
  def self.pixels_per_minute
    return 0.7
  end
  
  def self.min_diff_time
    return 5
  end
end
