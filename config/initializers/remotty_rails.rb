file_path = Rails.root.join('config', "remotty.yml")
raise 'You have not created config/remotty.yml' unless File.exists?(file_path)
remotty_yml = YAML.load_file(file_path)

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
