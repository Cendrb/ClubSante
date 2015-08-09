class AddSingleUseToTickets < ActiveRecord::Migration
  def change
    add_column :tickets, :single_use, :boolean
  end
end
