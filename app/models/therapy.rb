class Therapy < ActiveRecord::Base
  has_one :calendar, dependent: :destroy
  has_and_belongs_to_many :therapy_categories

  validates_presence_of :name, :capacity, :duration_in_minutes
  before_create :init_dependent

  def init_dependent
    self.calendar = Calendar.create!
    true
  end

  def can_single_use
    return single_use_category
  end

  def single_use_category
    if single_use_category_id
      return TherapyCategory.find_by_id(single_use_category_id)
    else
      return nil
    end
  end
end
