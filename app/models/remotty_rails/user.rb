module RemottyRails
  class User < ActiveRecord::Base
    belongs_to :participation, foreign_key: :remotty_rails_participation_id

    validates :participation, presence: true

    def room
      self.participation.room
    end

    def self.find_or_create_with_omniauth(auth)
      room = Room.create_with(token: auth['info']['room_token']).find_or_create_by(id: auth['info']['room_id'])
      room.refresh!
      room.users.find_by(id: auth['uid'])
    end

    def groups
      RemottyRails::Group.list(self.token)
    end

    def post_comment(participation, content, show_log = false)
      RemottyRails.access_token(token).post("/api/v1/rooms/participations/#{participation.id}/comments.json", body: { comment: { content: content, show_log: show_log } }).parsed
    end

    def post_entry(group_id, content, parent_id = nil, with_archive = false)
      RemottyRails::Group.new(self.token, id: group_id).post_entry(content, parent_id, with_archive)
    end
  end
end
