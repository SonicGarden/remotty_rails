class CreateRemottyRailsUsers < ActiveRecord::Migration[4.2]
  def change
    create_table :remotty_rails_users do |t|
      t.references :remotty_rails_participation, index: true, foreign_key: true
      t.string :email
      t.string :name
      t.string :icon_url
      t.string :token

      t.timestamps null: false
    end
  end
end
