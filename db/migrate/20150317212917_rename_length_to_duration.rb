class RenameLengthToDuration < ActiveRecord::Migration
  def change
    remove_column :therapies, :length_in_minutes
    add_column :therapies, :duration_in_minutes, :integer
  end
end
