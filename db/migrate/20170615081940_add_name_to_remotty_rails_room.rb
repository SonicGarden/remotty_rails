class AddNameToRemottyRailsRoom < ActiveRecord::Migration[5.0]
  def change
    add_column :remotty_rails_rooms, :name, :string
  end
end
