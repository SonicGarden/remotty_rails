$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "remotty_rails/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "remotty_rails"
  s.version     = RemottyRails::VERSION
  s.authors     = ["SonicGarden"]
  s.email       = ["luckofwise@sonicgarden.jp"]
  s.homepage    = "https://www.remotty.net"
  s.summary     = %q{Remotty Ruby Client}
  s.description = %q{Remotty Ruby Client}
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", ">= 4.2.10"
  s.add_dependency "omniauth"
  s.add_dependency "oauth2"
  s.add_dependency "omniauth-oauth2", '~> 1.3.1'
  s.add_dependency "rest-client"
end
