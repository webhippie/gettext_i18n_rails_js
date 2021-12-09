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
  module Task
    extend self

    def po_to_json
      set_config

      if files_list.empty?
        puts "Couldn't find PO files in #{locale_path}, run 'rake gettext:find'"
      else
        files_iterate
        print_footer
      end
    end

    protected

    def destination(lang)
      path = output_path.join(lang)
      path.mkpath

      path.join("app.js").open("w") do |f|
        f.rewind
        f.write yield
      end

      puts "Created app.js in #{path}"
    end

    def lang_for(file)
      file.dirname.basename.to_s
    end

    def json_for(file)
      PoToJson.new(
        file.to_s
      ).generate_for_jed(
        lang_for(file),
        GettextI18nRailsJs.config.jed_options
      )
    end

    def set_config
      GettextI18nRailsJs::Parser::Javascript
        .gettext_function = GettextI18nRailsJs.config.javascript_function

      GettextI18nRailsJs::Parser::Handlebars
        .gettext_function = GettextI18nRailsJs.config.handlebars_function
    end

    def files_iterate
      files_list.each do |input|
        # Language is used for filenames, while language code is used as the
        # in-app language code. So for instance, simplified chinese will live
        # in app/assets/locale/zh_CN/app.js but inside the file the language
        # will be referred to as locales['zh-CN']. This is to adapt to the
        # existing gettext_rails convention.

        destination(
          lang_for(input)
        ) do
          json_for(input)
        end
      end
    end

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

    def print_footer
      puts
      puts "All files created, make sure they are being added to your assets."
      puts "If they are not, you can add them with this line (configurable):"
      puts
      puts "//= require_tree ./locale"
      puts "//= require gettext/all"
      puts
    end
  end
end
