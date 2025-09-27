# frozen_string_literal: true

$:.push File.expand_path("../lib", __FILE__)
$:.push File.expand_path("../../lib", __dir__)

require "open_project/paperless/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "openproject-paperless"
  s.version     = OpenProject::Paperless::VERSION

  s.authors     = "Twistedpixel"
  s.email       = "webstuffirl@gmail.com"
  s.homepage    = "https://community.openproject.org/projects/paperless"  # TODO check this URL
  s.summary     = "OpenProject Paperless"
  s.description = "Integrates Paperless-ngx document management with OpenProject"
  s.license     = "GPL-3.0" # e.g. "MIT" or "GPLv3"

  s.files = Dir["{app,config,db,lib}/**/*"] + %w(CHANGELOG.md README.md)
  s.add_dependency "httparty", "~> 0.21"
  s.add_dependency "jwt", "~> 2.7"
  s.add_development_dependency "rspec-rails"
end
