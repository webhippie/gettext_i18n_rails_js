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

module GettextI18nRailsJs
  module Parser
    module Base
      extend self

      # The gettext function name can be configured at the module level as
      # gettext_function. This is to provide a way to avoid
      # conflicts with other javascript libraries. You only need to define
      # the base function name to replace "_" and all the other variants
      # (s_, n_, N_) will be deduced automatically.
      attr_writer :gettext_function

      def gettext_function
        @gettext_function ||= "__"
      end

      # We're lazy and klumsy, so this is a regex based parser that looks for
      # invocations of the various gettext functions. Once captured, we scan
      # them once again to fetch all the function arguments. Invoke regex
      # captures like this:
      #
      # javascript source: "#{ __('hello') } #{ __("wor)ld") }"
      # matches:
      # [0]: __('hello')
      # [1]: __
      # [2]: 'hello'
      #
      # javascript source: __('item', 'items', 33)
      # matches:
      # [0]: __('item', 'items', 33)
      # [1]: __
      # [2]: 'item', 'items', 33
      #
      # handlebars source: "{{ _ "foo"}}"
      # matches:
      # [0]: __('foo')
      # [1]: __
      # [2]: 'foo'
      #
      # handlebars source: "{{ _ "foo" "foos" 3}}"
      # matches:
      # [0]: __('foo', 'foos', 3)
      # [1]: __
      # [2]: 'foo', 'foos', 3
      #
      # The PO file outputs to a "" string.
      # single quotes are unescped (if they are escaped)
      # double quotes are escaped (if they are not already escaped)
      def parse(file, _msgids = [])
        collect_for(file) do |function, arguments, line|
          key = arguments.scan(
            /('(?:[^'\\]|\\.)*'|"(?:[^"\\]|\\.)*"|`(?:[^`\\]|\\.)*`)/
          ).collect do |match|
            contents = match.first[1..-2]
            contents.gsub("\\'", "'").gsub(/(?<=[^\\])"/, "\\\"")
          end.join(separator_for(function))

          next if key == ""

          results_for(key, file, line)
        end
      end

      protected

      def cleanup_multiline_line(value)
        result = value.chomp
        result.strip
      end

      def cleanup_value(value)
        value
          .tr("\n", "\n")
          .tr("\t", "\t")
          .tr("\0", "\0")
      end

      def separator_for(value)
        if value == "n#{gettext_function}"
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
    end
  end
end
