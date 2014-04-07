require 'gettext/tools/xgettext'

module GettextI18nRailsJs
  class HandlebarsParser

    class << self
      # The gettext function name can be configured at the module level as handlebars_gettext_function
      attr_accessor :handlebars_gettext_function
    end

    self.handlebars_gettext_function = '_'

    def self.target?(file)
      [/\.handlebars\Z/, /\.handlebars.erb\Z/, /\.mustache\Z/].any? {|regexp| file.match regexp}
    end

    # We're lazy and klumsy, so this is a regex based parser that looks for
    # invocations of the various gettext functions. Once captured, we
    # scan them once again to fetch all the function arguments.
    # Invoke regex captures like this:
    # source: "{{ _ "foo"}}"
    # matches:
    # [0]: {{_ "foo"}}
    # [1]: _
    # [2]: "foo"
    #
    # source: "{{ _ "foo" "foos" 3}}"
    # matches:
    # [0]: {{ _ "foo" "foos" 3}}
    # [1]: _
    # [2]: "foo" "foos" 3'

    def self.parse(file, msgids = [])
      cookie = self.handlebars_gettext_function

      # We first parse full invocations
      invoke_regex = /
        \B[{]{2}(([snN]?#{cookie})      # Matches the function handlebars helper call grouping "{{"
                  \s+                   # and a parenthesis to start the arguments to the function.
                  (".*?"                # Then double quote string
                   .*?                  # remaining arguments
                 )
                )
          [}]{2}                   # function call closing parenthesis
      /x

      File.read(file).scan(invoke_regex).collect do |whole, function, arguments|
        separator = function == "n#{cookie}" ? "\000" : "\004"
        key = arguments.scan(/('(?:[^'\\]|\\.)*'|"(?:[^"\\]|\\.)*")/).
          collect{|match| match.first[1..-2]}.
          join(separator)
        next if key == ''
        key.gsub!("\n", '\n')
        key.gsub!("\t", '\t')
        key.gsub!("\0", '\0')

        [key, "#{file}:1"]
      end.compact
    end

  end
end

require 'gettext_i18n_rails/gettext_hooks'
GettextI18nRails::GettextHooks.add_parser(GettextI18nRailsJs::HandlebarsParser)
