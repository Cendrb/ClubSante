class TimetableModification < ActiveRecord::Base
  has_many :exercise_modifications, dependent: :destroy
  belongs_to :calendar
  
  def self.pixels_per_minute
    return 1
  end
end
