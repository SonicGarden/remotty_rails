module RemottyRails
  class Room < ActiveRecord::Base
    has_many :participations, foreign_key: :remotty_rails_room_id
    has_many :users, through: :participations, foreign_key: :remotty_rails_participation_id

    validates :token, presence: true

    def refresh!
      room_json = JSON.parse RestClient.get(File.join(REMOTTY_URL, "/room_api/v1/rooms.json?token=#{self.token}"))
      participations_json = room_json['participations']
      delete_participation_ids = self.participations.pluck(:id) - participations_json.map { |p| p['id'] }
      participations_json.each do |participation_json|
        participation = self.participations.find_or_create_by(id: participation_json['id'])
        user = User.find_or_initialize_by(participation: participation)
        user.id = participation_json['user_id']
        user.name = participation_json['name']
        user.email = participation_json['email']
        user.icon_url = participation_json['icon_url']
        user.save
      end
      self.participations.where(id: delete_participation_ids).each(&:destroy)
    end

    def post_comment(participation, content, show_log = false)
      RestClient.post(File.join(REMOTTY_URL, "/room_api/v1/rooms/participations/#{participation.id}/comments.json?token=#{self.token}"),
                      comment: {content: content, show_log: show_log})
    end
  end
end
