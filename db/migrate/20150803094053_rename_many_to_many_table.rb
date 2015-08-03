class RenameManyToManyTable < ActiveRecord::Migration
  def change
    rename_table :therapy_categories_therapies, :therapies_therapy_categories
  end
end
