class ChangeSingleUseSystem < ActiveRecord::Migration
  def change
    remove_column :therapies, :can_single_use
    add_column :therapies, :single_use_category_id, :integer
  end
end
