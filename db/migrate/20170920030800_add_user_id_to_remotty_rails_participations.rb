class AddUserIdToRemottyRailsParticipations < ActiveRecord::Migration
  def change
    add_column :remotty_rails_participations, :remotty_rails_user_id, :integer
    add_index :remotty_rails_participations, :remotty_rails_user_id
  end
end
