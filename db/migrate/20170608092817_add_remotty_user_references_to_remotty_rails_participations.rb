class AddRemottyUserReferencesToRemottyRailsParticipations < ActiveRecord::Migration
  def change
    add_reference :remotty_rails_participations, :remotty_rails_user, null: true
  end
end
