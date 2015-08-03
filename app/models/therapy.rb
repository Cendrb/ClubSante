class Therapy < ActiveRecord::Base
  has_one :calendar, dependent: :destroy
  has_and_belongs_to_many :therapy_categories
  
  validates_presence_of :name, :capacity, :duration_in_minutes
  before_create :init_dependent
  
  def init_dependent
     self.calendar = Calendar.create
     true
  end
end
