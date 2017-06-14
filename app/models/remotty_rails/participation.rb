module RemottyRails
  class Participation < ActiveRecord::Base
    belongs_to :room, foreign_key: :remotty_rails_room_id
    belongs_to :user,foreign_key: :remotty_rails_user_id
  end
end
