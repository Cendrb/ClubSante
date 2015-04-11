class AddTherapyIdToTickets < ActiveRecord::Migration
  def change
    add_column :tickets, :therapy_id, :integer
  end
end
