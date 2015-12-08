module RemottyRails
  class Engine < ::Rails::Engine
    isolate_namespace RemottyRails

    config.after_initialize do
      ApplicationController.include RemottyRails::SessionsHelper
    end
  end
end
