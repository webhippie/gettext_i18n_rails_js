if RUBY_PLATFORM != 'java'
  dir = File.dirname(__FILE__)
  require File.join(dir, '../gettext_i18n_rails_js/js_and_coffee_parser')
  require File.join(dir, '../gettext_i18n_rails_js/handlebars_parser')
  require 'gettext_i18n_rails/tasks'
  require File.join(dir, '../gettext_i18n_rails_js/tasks')
end
