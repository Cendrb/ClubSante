class AddSortingOrderToTherapies < ActiveRecord::Migration
  def change
    add_column :therapies, :sorting_order, :integer
  end
end
