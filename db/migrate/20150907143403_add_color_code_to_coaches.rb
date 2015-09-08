class AddColorCodeToCoaches < ActiveRecord::Migration
  def change
    add_column :coaches, :color_code, :string
  end
end
