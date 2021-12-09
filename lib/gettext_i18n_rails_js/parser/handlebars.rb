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

require "gettext/tools/xgettext"
require "gettext_i18n_rails/gettext_hooks"
require_relative "base"

module GettextI18nRailsJs
  module Parser
    module Handlebars
      include Base
      extend self

      def target?(file)
        [
          /\.handlebars\Z/,
          /\.handlebars.erb\Z/,
          /\.hbs\Z/,
          /\.hbs.erb\Z/,
          /\.mustache\Z/,
          /\.mustache.erb\Z/
        ].any? { |regexp| file.match regexp }
      end

      protected

      def collect_for(value)
        ::File.read(
          value
        ).scan(invoke_regex).collect do |_whole, function, arguments|
          yield(function, arguments, 1)
        end.compact
      end

      def invoke_regex
        #
        # * Matches the function handlebars helper call grouping "{{"
        # * A parenthesis to start the arguments to the function
        # * Then double quote string
        # * Remaining arguments
        # * Function call closing parenthesis
        #
        /
          \B[{]{2}(
            ([snN]?#{gettext_function})
            \s+
            (
              (["'])(?:\\?+.)*?\4
              (?:\s+(["'])(?:\\?+.)*?\5)?
            )
            .*?
          )
          [}]{2}
        /xm
      end
    end
  end
end

GettextI18nRails::GettextHooks.add_parser(
  GettextI18nRailsJs::Parser::Handlebars
)
