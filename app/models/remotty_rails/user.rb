module RemottyRails
  class User < ActiveRecord::Base
    has_many :participations, dependent: :delete_all, foreign_key: :remotty_rails_user_id
    has_many :rooms, ->{ where.not(token: nil) }, through: :participations
    has_one :participation, -> { order('remotty_rails_participations.id ASC') }, foreign_key: :remotty_rails_user_id
    has_one :room, through: :participation

    def self.find_or_create_with_omniauth(auth)
      auth['info']['rooms'].each do |room_attribute|
        room = RemottyRails::Room.find_or_initialize_by(id: room_attribute['id'])
        room.token = room_attribute['room_token']
        room.name = room_attribute['name']
        room.save!
        room.refresh!
      end

      user = User.find(auth['uid'])
      user.update_column(:token, auth.credentials.token)
      user
    end

    def groups(target_room = room)
      RemottyRails::Group.list(self.token, target_room.id)
    end

    def post_comment(participation, content, show_log = false)
      result = RemottyRails.access_token(token).post("/api/v1/rooms/participations/#{participation.id}/comments.json?room_id=#{participation.room.id}", body: { comment: { content: content, show_log: show_log } })
      JSON.parse(result.body)
    end

    def post_entry(group_id, content, parent_id = nil, with_archive = false)
      RemottyRails::Group.new(self.token, id: group_id).post_entry(content, parent_id, with_archive)
    end
  end
end
