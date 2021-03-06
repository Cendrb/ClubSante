class TherapyCategory < ActiveRecord::Base
  has_and_belongs_to_many :therapies
  has_many :tickets
  
  scope :for_therapy, ->(therapy) { 
    joins(:therapies)
    .where("therapies.id = ?", therapy.id) }
  
  def includes?(therapy)
    return therapies.where(id: therapy.id).count > 0
  end
end
