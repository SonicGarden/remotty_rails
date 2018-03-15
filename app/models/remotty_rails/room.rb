module RemottyRails
  class Room < ActiveRecord::Base
    has_many :participations, foreign_key: :remotty_rails_room_id
    has_many :users, through: :participations, foreign_key: :remotty_rails_participation_id

    scope :active, -> { where.not(token: nil) }

    def refresh!
      begin
        room_json = JSON.parse RestClient.get(File.join(REMOTTY_URL, "/room_api/v1/rooms.json?token=#{self.token}"))
        participations_json = room_json['participations']

        participations_json.each do |participation_json|
          user = RemottyRails::User.find_or_initialize_by(id: participation_json['user_id'])
          user.name = participation_json['name']
          user.email = participation_json['email']
          user.icon_url = participation_json['icon_url']
          user.save

          participation = self.participations.find_or_initialize_by(id: participation_json['id'])
          participation.user = user
          participation.save
        end

        delete_participation_ids = self.participations.pluck(:id) - participations_json.map { |p| p['id'] }
        self.participations.where(id: delete_participation_ids).each(&:destroy)
      rescue RestClient::ExceptionWithResponse => e
        if e.response.code == 401
          deactivate
        end
      end
    end

    def post_comment(participation, content, show_log = false)
      result = RestClient.post(File.join(REMOTTY_URL, "/room_api/v1/rooms/participations/#{participation.id}/comments.json?token=#{token}"),
                      comment: {content: content, show_log: show_log})
      JSON.parse(result.body)
    end

    def post_entry(group, content, parent_id = nil, with_archive = false)
      result = RestClient.post(File.join(REMOTTY_URL, "/room_api/v1/groups/#{group.id}/entries.json?token=#{token}"),
                      entry: {content: content, parent_id: parent_id, with_archive: with_archive})
      JSON.parse(result.body)
    end

    private

    def deactivate
      self.update(token: nil)
    end
  end
end
