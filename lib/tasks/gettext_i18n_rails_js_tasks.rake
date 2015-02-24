# -*- coding: UTF-8 -*-
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

require "gettext_i18n_rails/tasks"

namespace :gettext do
  desc "Convert PO files to JS files"
  task po_to_json: :environment do
    GettextI18nRailsJs::Parser::Javascript
      .gettext_function = config[:javascript_function]

    GettextI18nRailsJs::Parser::Handlebars
      .gettext_function = config[:handlebars_function]

    if files_list.empty?
      puts "Couldn't find PO files in #{locale_path}, run 'rake gettext:find'"
    else
      files_list.each do |input|
        # Language is used for filenames, while language code is used as the
        # in-app language code. So for instance, simplified chinese will live
        # in app/assets/locale/zh_CN/app.js but inside the file the language
        # will be referred to as locales['zh-CN']. This is to adapt to the
        # existing gettext_rails convention.

        language = input.dirname.basename.to_s
        language_code = language.gsub("_", "-")

        destination = output_path.join(language)
        destination.mkpath

        json = PoToJson.new(
          input.to_s
        ).generate_for_jed(
          language_code,
          config[:jed_options].symbolize_keys
        )

        destination.join("app.js").open("w") do |f|
          f.rewind
          f.write(json)
        end

        puts "Created app.js in #{destination}"
      end

      puts
      puts "All files created, make sure they are being added to your assets."
      puts "If they are not, you can add them with this line (configurable):"
      puts
      puts "//= require_tree ./locale"
      puts "//= require gettext/all"
      puts
    end
  end

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
    Rails.root.join(
      config[:output_path]
    )
  end

  def config
    @config ||= begin
      file = Rails.root.join(
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

  # Required for gettext to filter the files
  def files_to_translate
    folders = [
      "app",
      "lib",
      "config",
      locale_path
    ].join(",")

    exts = [
      "rb",
      "erb",
      "haml",
      "slim",
      "rhtml",
      "js",
      "coffee",
      "handlebars",
      "hbs",
      "mustache"
    ].join(",")

    Dir.glob(
      "{#{folders}}/**/*.{#{exts}}"
    )
  end
end
