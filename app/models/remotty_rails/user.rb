module RemottyRails
  class User < ActiveRecord::Base
    has_many :participations, dependent: :delete_all, foreign_key: :remotty_rails_user_id
    has_many :rooms, through: :participations
    has_one :participation, -> { order('remotty_rails_participations.created_at ASC') }, foreign_key: :remotty_rails_user_id
    has_one :room, through: :participation

    def self.find_or_create_with_omniauth(auth)
      me = RemottyRails.access_token(auth.credentials.token).get('/api/v1/me.json').parsed
      me['rooms'].each do |room_attribute|
        next if room_attribute['room_token'].blank?
        room = RemottyRails::Room.find_or_create_by(id: room_attribute['id'])
        room.token = room_attribute['room_token']
        room.name = room_attribute['name']
        room.save!
        room.refresh!
      end

      first_room = RemottyRails::Room.find(me['room_id'])
      user = first_room.users.find(auth['uid'])
      user.update_column(:token, auth.credentials.token)
      user
    end

    def groups
      RemottyRails::Group.list(self.token)
    end

    def post_comment(participation, content, show_log = false)
      result = RemottyRails.access_token(token).post("/api/v1/rooms/participations/#{participation.id}/comments.json?room_id=#{participation.room.id}", body: { comment: { content: content, show_log: show_log } })
      JSON.parse(result.body)
    end

    def post_entry(group_id, content, parent_id = nil, with_archive = false)
      result = RemottyRails::Group.new(self.token, id: group_id).post_entry(content, parent_id, with_archive)
      JSON.parse(result.body)
    end
  end
end
