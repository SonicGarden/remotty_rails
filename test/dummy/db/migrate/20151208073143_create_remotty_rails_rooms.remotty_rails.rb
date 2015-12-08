# This migration comes from remotty_rails (originally 20151206125115)
class CreateRemottyRailsRooms < ActiveRecord::Migration
  def change
    create_table :remotty_rails_rooms do |t|
      t.string :token

      t.timestamps null: false
    end
  end
end
