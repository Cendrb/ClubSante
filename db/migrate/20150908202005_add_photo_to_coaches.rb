class AddPhotoToCoaches < ActiveRecord::Migration
  def change
    add_column :coaches, :photo, :string
  end
end
