module RemottyRails
  class Participation < ActiveRecord::Base
    belongs_to :room, foreign_key: :remotty_rails_room_id
    has_one :user, dependent: :delete, foreign_key: :remotty_rails_participation_id

  end
end
