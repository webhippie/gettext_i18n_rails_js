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

module GettextI18nRailsJs
  module Parser
    module Javascript
      extend self

      # The gettext function name can be configured at the module level as
      # javascript_gettext_function. This is to provide a way to avoid
      # conflicts with other javascript libraries. You only need to define
      # the base function name to replace "_" and all the other variants
      # (s_, n_, N_) will be deduced automatically.
      attr_accessor :javascript_gettext_function

      def javascript_gettext_function
        @javascript_gettext_function ||= "__"
      end

      def target?(file)
        [
          ".js",
          ".coffee"
        ].include? ::File.extname(file)
      end

      # We're lazy and klumsy, so this is a regex based parser that looks for
      # invocations of the various gettext functions. Once captured, we scan
      # them once again to fetch all the function arguments. Invoke regex
      # captures like this:
      #
      # source: "#{ __('hello') } #{ __("wor)ld") }"
      # matches:
      # [0]: __('hello')
      # [1]: __
      # [2]: 'hello'
      #
      # source: __('item', 'items', 33)
      # matches:
      # [0]: __('item', 'items', 33)
      # [1]: __
      # [2]: 'item', 'items', 33
      def parse(file, _msgids = [])
        collect_for(file) do |function, arguments, line|
          key = arguments.scan(
            /('(?:[^'\\]|\\.)*'|"(?:[^"\\]|\\.)*")/
          ).collect do |match|
            match.first[1..-2]
          end.join(separator_for(function))

          next if key == ""
          results_for(key, file, line)
        end
      end

      protected

      def cleanup_value(value)
        value
          .gsub("\n", "\n")
          .gsub("\t", "\t")
          .gsub("\0", "\0")
      end

      def collect_for(value)
        ::File.new(
          value
        ).each_line.each_with_index.collect do |line, idx|
          line.scan(invoke_regex).collect do |function, arguments|
            yield(function, arguments, idx + 1)
          end
        end.inject(:+).compact
      end

      def separator_for(value)
        if value == "n#{javascript_gettext_function}"
          "\000"
        else
          "\004"
        end
      end

      def results_for(key, file, line)
        [
          cleanup_value(key),
          [file, line].join(":")
        ]
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
          (\b[snN]?#{javascript_gettext_function})
          \(
            (
              (#{arg_regex},)*
              #{arg_regex}
            )?
          \)
        /x
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
            [a-zA-Z0-9_\.()]*?
          )
          \s*
        /x
      end
    end
  end
end

GettextI18nRails::GettextHooks.add_parser(
  GettextI18nRailsJs::Parser::Javascript
)
