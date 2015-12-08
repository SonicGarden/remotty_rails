require 'active_support'
require 'active_support/core_ext'
require 'json'
require 'remotty_rails/configuration'
require 'omniauth'
require 'omniauth/strategies/remotty'
require 'rest-client'

require 'remotty_rails/engine'

module RemottyRails
  class << self
    attr_accessor :configuration
  end

  def self.client
    RemottyRails.configuration.client
  end

  def self.access_token(token)
    RemottyRails.configuration.access_token(token)
  end

  # Call this method to modify defaults in your initializers.
  #
  # @example
  #   Remotty.setup do |config|
  #     config.client_id = 'your client id'
  #     config.client_secret = 'your client secret'
  #     config.site = 'https://www.remotty.net'
  #   end
  def self.setup
    self.configuration ||= Configuration.new
    yield configuration
  end
end
