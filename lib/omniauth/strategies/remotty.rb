require 'omniauth-oauth2'

module OmniAuth
  module Strategies
    class Remotty < OmniAuth::Strategies::OAuth2
      option :name, :remotty

      option :client_options, { :site => 'https://www.remotty.net',
                                :authorize_path => '/oauth/authorize' }

      uid do
        raw_info['id'].to_s
      end

      info do
        {
          :email => raw_info['email'],
          :name => raw_info['name'],
          :icon_url => raw_info['icon_url'],
          :room_id => raw_info['room_id'],
          :room_token => raw_info['room_token'],
          :participation_id => raw_info['participation_id'],
        }
      end

      def raw_info
        @raw_info ||= access_token.get('/api/v1/me.json').parsed
      end
    end
  end
end
