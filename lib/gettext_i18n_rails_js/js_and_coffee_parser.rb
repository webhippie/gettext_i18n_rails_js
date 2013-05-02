require 'gettext/tools/xgettext'

module GettextI18nRailsJs
  class JsAndCoffeeParser

    class << self
      # The gettext function name can be configured at the module level as js_gettext_function
      # This is to provide a way to avoid conflicts with other javascript libraries.
      # You only need to define the base function name to replace '_' and all the
      # other variants (s_, n_, N_) will be deduced automatically.
      attr_accessor :js_gettext_function
    end
    self.js_gettext_function = '__'

    def self.target?(file)
      ['.js', '.coffee'].include?(File.extname(file))
    end

    # We're lazy and klumsy, so this is a regex based parser that looks for
    # invocations of the various gettext functions. Once captured, we
    # scan them once again to fetch all the function arguments.
    # Invoke regex captures like this:
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
    def self.parse(file, msgids = [])
      _ = self.js_gettext_function

      arg_regex = /
        \s*                     # Some whitespace
        ('(?:[^'\\]|\\.)*?'|    # A token inside the argument list, like a single quoted string
         "(?:[^"\\]|\\.)*?"|    # ...Double quote string, both support escapes
         [a-zA-Z0-9_\.()]*?)    # ...a number, variable name, or called function lik: 33, foo, Foo.bar()
        \s*                     # More whitespace
      /x

      # We first parse full invocations
      invoke_regex = /
        (\b[snN]?#{_})          # Matches the function call grouping the method used (__, n__, N__, etc)
          \(                    # and a parenthesis to start the arguments to the function.
            ((#{arg_regex},)*   # There may be many arguments to the same function call
              #{arg_regex})?    # then the last, or only argument to the function call.
          \)                    # function call closing parenthesis
      /x

      File.new(file).each_line.each_with_index.collect do |line, idx|
        line.scan(invoke_regex).collect do |function, arguments|
          separator = function == "n#{_}" ? "\000" : "\004"
          key = arguments.scan(/('(?:[^'\\]|\\.)*'|"(?:[^"\\]|\\.)*")/).
            collect{|match| match.first[1..-2]}.
            join(separator)
          next if key == ''
          key.gsub!("\n", '\n')
          key.gsub!("\t", '\t')
          key.gsub!("\0", '\0')

          [key, "#{file}:#{idx+1}"]
        end
      end.inject(:+).compact
    end

  end
end

require 'gettext_i18n_rails/gettext_hooks'
GettextI18nRails::GettextHooks.add_parser(GettextI18nRailsJs::JsAndCoffeeParser)
