class Coach < ActiveRecord::Base
  has_many :exercise_templates
  has_many :exercise_modifications
  belongs_to :user

  after_validation :set_access_level
  
  scope :valid, -> { where("description != ?", "SYSTEM") }

  mount_uploader :photo, CoachPhotoUploader

  def set_access_level
    if(user && !user.access_for_level?(User.al_coach))
      user.access_level = User.al_coach
      user.save!
    end
  end

  def self.default_color
    return "#009900"
  end

  def self.full_color
    return "#dd2002"
  end

  def self.signed_color
    return "#ffcc00"
  end
  
  def self.get_nobody
    return Coach.where(description: "SYSTEM").first
  end
  
end
