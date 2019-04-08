class AddNameToRemottyRailsRoom < ActiveRecord::Migration
  def change
    add_column :remotty_rails_rooms, :name, :string
  end
end
