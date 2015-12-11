module RemottyRails
  class Engine < ::Rails::Engine
    isolate_namespace RemottyRails

    config.after_initialize do
    end
  end
end
