require "gettext_i18n_rails/tasks"

module GettextI18nRailsJs
  module Task
    extend self

    def files_list
      Pathname.glob(
        ::File.join(
          locale_path,
          "**",
          "*.po"
        )
      )
    end

    def output_path
      ::Rails.root.join(
        config[:output_path]
      )
    end

    def config
      @config ||= begin
        file = ::Rails.root.join(
          "config",
          "gettext_i18n_rails_js.yml"
        )

        defaults = {
          output_path: File.join(
            "app",
            "assets",
            "javascripts",
            "locale"
          ),
          handlebars_function: "__",
          javascript_function: "__",
          jed_options: {
            pretty: false
          }
        }

        if file.exist?
          yaml = YAML.load_file(file) || {}

          defaults.deep_merge(
            yaml
          ).with_indifferent_access
        else
          defaults.with_indifferent_access
        end
      end
    end
  end
end
