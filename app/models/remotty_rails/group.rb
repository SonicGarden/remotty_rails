module RemottyRails
  class Group
    attr_accessor :token
    attr_accessor :id, :name, :room_id

    def initialize(token, attributes = nil)
      self.token = token
      if attributes.present?
        attributes = attributes.stringify_keys
        self.id = attributes['id']
        self.name = attributes['name']
        self.room_id = attributes['room_id']
      end
    end

    def post_entry(content, parent_id = nil, with_archive = false)
      result = RemottyRails.access_token(token).post("/api/v1/groups/#{self.id}/entries.json", body: {entry: {content: content, parent_id: parent_id, with_archive: with_archive}})
      JSON.parse(result.body)
    end

    def self.list(token)
      response = RemottyRails.access_token(token).get('/api/v1/groups.json').parsed
      Array(response).map { |attr| RemottyRails::Group.new(token, attr) }
    end
  end
end
