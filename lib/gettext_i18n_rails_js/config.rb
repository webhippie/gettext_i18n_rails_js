# frozen_string_literal: true

#
# Copyright (c) 2012-2015 Dropmysite.com <https://dropmyemail.com>
# Copyright (c) 2015 Webhippie <http://www.webhippie.de>
#
# Permission is hereby granted, free of charge, to any person obtaining
# a copy of this software and associated documentation files (the
# "Software"), to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge, publish,
# distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so, subject to
# the following conditions:
#
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
# LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
# OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
# WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
#

module GettextI18nRailsJs
  class Config
    attr_accessor :output_path,
                  :handlebars_function,
                  :javascript_function,
                  :jed_options,
                  :rails_engine,
                  :domain

    def initialize(&block)
      @output_path = defaults[:output_path]
      @handlebars_function = defaults[:handlebars_function]
      @javascript_function = defaults[:javascript_function]
      @jed_options = defaults[:jed_options].symbolize_keys
      @rails_engine = defaults[:rails_engine]
      @domain = defaults[:domain]

      instance_eval(&block) if block_given?
    end

    protected

    def defaults
      file = ::Rails.root.join(
        "config",
        "gettext_i18n_rails_js.yml"
      )

      values = {
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
        },
        rails_engine: ::Rails,
        domain: "app"
      }

      if file.exist?
        yaml = YAML.load_file(file) || {}

        values.deep_merge(
          yaml
        ).with_indifferent_access
      else
        values.with_indifferent_access
      end
    end
  end
end
