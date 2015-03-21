class Gay < ActiveRecord::Migration
  def change
    remove_column :therapies, :calendar_id
  end
end
