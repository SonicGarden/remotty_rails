module RemottyRails
  class User < ActiveRecord::Base
    belongs_to :participation, foreign_key: :remotty_rails_participation_id

    validates :participation, presence: true

    def room
      self.participation.room
    end

    def self.find_or_create_with_omniauth(auth)
      room = RemottyRails::Room.find_or_create_by(id: auth['info']['room_id'])
      room.token = auth['info']['room_token']
      room.save!
      room.refresh!
      user = room.users.find_by(id: auth['uid'])
      user.update_column(:token, auth.credentials.token)
      user
    end

    def groups
      RemottyRails::Group.list(self.token)
    end

    def post_comment(participation, content, show_log = false)
      result = RemottyRails.access_token(token).post("/api/v1/rooms/participations/#{participation.id}/comments.json", body: { comment: { content: content, show_log: show_log } }).parsed
      JSON.parse(result.body)
    end

    def post_entry(group_id, content, parent_id = nil, with_archive = false)
      result = RemottyRails::Group.new(self.token, id: group_id).post_entry(content, parent_id, with_archive)
      JSON.parse(result.body)
    end
  end
end
