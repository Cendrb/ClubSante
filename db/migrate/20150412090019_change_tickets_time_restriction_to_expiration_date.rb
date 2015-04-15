class ChangeTicketsTimeRestrictionToExpirationDate < ActiveRecord::Migration
  def change
    remove_column :tickets, :time_restriction
    add_column :tickets, :time_restriction, :integer
  end
end
