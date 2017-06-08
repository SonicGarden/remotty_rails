class AddRemottyUserReferencesToRemottyRailsParticipations < ActiveRecord::Migration[4.2]
  def change
    add_reference :remotty_rails_participations, :remotty_rails_user
  end
end
