class ItIsBroken < ActiveRecord::Migration
  def change
    remove_column :exercises, :registerable_id
    remove_column :exercises, :registerable_type
    add_column :exercises, :exercise_modification_id, :integer
  end
end
