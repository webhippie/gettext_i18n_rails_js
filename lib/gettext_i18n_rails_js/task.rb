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

module GettextI18nRailsJs
  module Task
    extend self

    def po_to_json
      GettextI18nRailsJs::Parser::Javascript
        .gettext_function = GettextI18nRailsJs.config.javascript_function

      GettextI18nRailsJs::Parser::Handlebars
        .gettext_function = GettextI18nRailsJs.config.handlebars_function

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
            GettextI18nRailsJs.config.jed_options
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

    protected

    def files_list
      require "gettext_i18n_rails/tasks"

      ::Pathname.glob(
        ::File.join(
          locale_path,
          "**",
          "*.po"
        )
      )
    end

    def output_path
      ::Rails.root.join(
        GettextI18nRailsJs.config.output_path
      )
    end
  end
end
