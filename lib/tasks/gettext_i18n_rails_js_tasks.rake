if RUBY_PLATFORM != 'java'
  require_relative '../gettext_i18n_rails_js/js_and_coffee_parser'
  require_relative '../gettext_i18n_rails_js/handlebars_parser'
  require 'gettext_i18n_rails/tasks'
  require_relative '../gettext_i18n_rails_js/tasks'
end
