module RemottyRails
  class Participation < ActiveRecord::Base
    belongs_to :room
    has_one :user, dependent: :delete

  end
end
