require 'oauth2'

module RemottyRails
  class Configuration
    attr_accessor :client_id
    attr_accessor :client_secret
    attr_accessor :site

    def initialize
      self.site = 'https://www.remotty.net'
    end

    def client
      @client ||= OAuth2::Client.new(self.client_id, self.client_secret, site: self.site)
    end

    def access_token(token)
      OAuth2::AccessToken.new(self.client, token)
    end

  end
end
