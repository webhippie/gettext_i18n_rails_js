$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "gettext_i18n_rails_js/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name = "gettext_i18n_rails_js"
  s.authors = ["Nubis"]
  s.email = "nubis@woobiz.com.ar"
  s.homepage = "http://github.com/nubis/gettext_i18n_rails_js"
  s.summary = "Extends gettext_i18n_rails making your .po files available to client side javascript as JSON"
  s.description = "gettext_i18n_rails will find translations inside your .js and .coffee files, then it will create JSON versions of your .PO files and will let you serve them with the rest of your assets, thus letting you access all your translations offline from client side javascript."
  s.version = GettextI18nRailsJs::VERSION

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "Readme.md"]

  s.add_dependency "rails", "~> 3.2.0"
  s.add_dependency "gettext_i18n_rails", ">= 0.7.1"
  s.add_dependency "po_to_json", '>= 0.0.6'

  s.add_development_dependency "sqlite3"
  s.add_development_dependency "rspec", "~>2"
  s.add_development_dependency "gettext", ">= 2.3.0"
end
