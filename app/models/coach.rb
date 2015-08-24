class Coach < ActiveRecord::Base
  has_many :exercise_templates
  has_many :exercise_modifications
  belongs_to :user

  after_validation :set_access_level
  
  scope :valid, -> { where("description != ?", "SYSTEM") }

  def set_access_level
    if(user && !user.access_for_level?(User.al_coach))
      user.access_level = User.al_coach
      user.save!
    end
  end
  
  def self.get_nobody
    return Coach.where(description: "SYSTEM").first
  end
  
end
