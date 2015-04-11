class RemoveUserIdFromEntries < ActiveRecord::Migration
  def change
    remove_column :entries, :user_id
  end
end
