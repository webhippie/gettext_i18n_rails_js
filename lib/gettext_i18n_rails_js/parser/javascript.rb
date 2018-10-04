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

require "gettext/tools/xgettext"
require "gettext_i18n_rails/gettext_hooks"
require_relative "base"

module GettextI18nRailsJs
  module Parser
    module Javascript
      include Base
      extend self

      def target?(file)
        [
          ".js",
          ".jsx",
          ".coffee"
        ].include? ::File.extname(file)
      end

      protected

      def collect_for(value)
        ::File.open(value) do |f|
          multiline = false
          line_no = 0
          buffer = ""
          f.each_line.each_with_index.collect do |line, idx|
            if multiline
              buffer << cleanup_multiline_line(line)
            else
              buffer = line
              line_no = idx + 1
            end

            if invoke_regex =~ buffer
              multiline = false
              buffer.scan(invoke_regex).collect do |function, arguments|
                yield(function, arguments, line_no)
              end
            elsif invoke_open_regex =~ buffer
              buffer << cleanup_multiline_line(buffer) unless multiline
              buffer << " "
              multiline = true
              []
            else
              []
            end
          end.inject([], :+).compact
        end
      end

      def invoke_open_regex
        #
        # * Matches the function call grouping the method used (__, n__, N__)
        # * A parenthesis to start the arguments to the function.
        # * Used to identify translation start on a single line
        #

        /
          (\b[snN]?#{gettext_function})\(
        /x
      end

      def invoke_regex
        #
        # * Matches the function call grouping the method used (__, n__, N__)
        # * A parenthesis to start the arguments to the function.
        # * There may be many arguments to the same function call
        # * Then the last, or only argument to the function call.
        # * Function call closing parenthesis
        #

        /
          (\b[snN]?#{gettext_function})
          \(
            (
              (#{arg_regex},)*
              #{arg_regex}
            )?
          \)
        /xm
      end

      def arg_regex
        #
        # * Some whitespace
        # * A token inside the argument list, like a single quoted string
        # * Double quote string, both support escapes
        # * A number, variable name, or called function lik: 33, foo, Foo.bar()
        # * More whitespace
        #

        /
          \s*
          (
            '(?:[^'\\]|\\.)*?'|
            "(?:[^"\\]|\\.)*?"|
            `(?:[^`\\]|\\.)*?`|
            [a-zA-Z0-9_\.()]*?
          )
          \s*
        /xm
      end
    end
  end
end

GettextI18nRails::GettextHooks.add_parser(
  GettextI18nRailsJs::Parser::Javascript
)
