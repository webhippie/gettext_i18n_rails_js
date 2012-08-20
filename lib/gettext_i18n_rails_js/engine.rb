# We need a rails engine so that the asset pipeline knows there are assets
# provided by this gem
require 'rails'
module GettextI18nRailsJs
  module Rails
    class Engine < ::Rails::Engine
    end
  end
end
