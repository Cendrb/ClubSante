class ChangeTicketsToTherapyCategory < ActiveRecord::Migration
  def change
    rename_column :tickets, :therapy_id, :therapy_category_id
  end
end
