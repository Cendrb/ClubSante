class CreateTherapyCategoriesTherapies < ActiveRecord::Migration
  def change
    create_table :therapy_categories_therapies, id: false do |t|
      t.belongs_to :therapy, index: true
      t.belongs_to :therapy_category, index: true
    end
  end
end
