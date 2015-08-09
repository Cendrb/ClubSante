class AddCanSingleUseToTherapies < ActiveRecord::Migration
  def change
    add_column :therapies, :can_single_use, :boolean
  end
end
