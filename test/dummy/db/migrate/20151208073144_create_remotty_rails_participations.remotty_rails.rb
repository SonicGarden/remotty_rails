# This migration comes from remotty_rails (originally 20151206125233)
class CreateRemottyRailsParticipations < ActiveRecord::Migration
  def change
    create_table :remotty_rails_participations do |t|
      t.references :remotty_rails_room, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
