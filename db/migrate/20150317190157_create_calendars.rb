class CreateCalendars < ActiveRecord::Migration
  def change
    create_table :calendars do |t|
      t.belongs_to :therapy, index: true

      t.timestamps null: false
    end
  end
end
