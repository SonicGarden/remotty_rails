file_path = Rails.root.join('config', "remotty.#{Rails.env}.yml")
file_path = Rails.root.join('config', "remotty.yml") unless File.exists?(file_path)
raise 'You have not created config/remotty.yml' unless File.exists?(file_path)
remotty_yml = YAML.load(ERB.new(file_path.read).result)

REMOTTY_URL = remotty_yml['remotty_url'] || 'https://www.remotty.net'
Rails.application.config.middleware.use OmniAuth::Builder do
  provider :remotty,
           remotty_yml['remotty_key'],
           remotty_yml['remotty_secret'],
           {client_options: {site: REMOTTY_URL}}
end

RemottyRails.setup do |config|
  config.client_id = remotty_yml['remotty_key']
  config.client_secret = remotty_yml['remotty_secret']
  config.site = REMOTTY_URL
end
