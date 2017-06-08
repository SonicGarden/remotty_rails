class CreateRemottyRailsParticipations < ActiveRecord::Migration[4.2]
  def change
    create_table :remotty_rails_participations do |t|
      t.references :remotty_rails_room, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
