class Coach < ActiveRecord::Base
  has_many :exercise_template
  
  scope :valid, -> { where("description != ?", "SYSTEM") }
  
  def self.get_nobody
    return Coach.where(description: "SYSTEM").first
  end
  
end
