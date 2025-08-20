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

require "spec_helper"

describe GettextI18nRailsJs::Parser::Javascript do
  let(:parser) { GettextI18nRailsJs::Parser::Javascript }

  describe "#target?" do
    it "targets .js" do
      expect(parser.target?("foo/bar/xxx.js")).to be_truthy
    end

    it "targets .coffee" do
      expect(parser.target?("foo/bar/xxx.coffee")).to be_truthy
    end

    it "targets .vue" do
      expect(parser.target?("foo/bar/xxx.vue")).to be_truthy
    end

    it "targets .jsx" do
      expect(parser.target?("foo/bar/xxx.jsx")).to be_truthy
    end

    it "does not target cows" do
      expect(parser.target?("foo/bar/xxx.cows")).to be_falsey
    end
  end

  describe "#parse" do
    it "finds plural messages" do
      content = <<-EOF
        bla = n__("xxxx", "yyyy", "zzzz", some_count)
      EOF

      with_file content do |path|
        expect(parser.parse(path, [])).to(
          eq(
            [
              ["xxxx\000yyyy\000zzzz", "#{path}:1"]
            ]
          )
        )
      end
    end

    it "finds namespaced messages" do
      content = <<-EOF
        bla = __("xxxx", "yyyy")
      EOF

      with_file content do |path|
        expect(parser.parse(path, [])).to(
          eq(
            [
              ["xxxx\004yyyy", "#{path}:1"]
            ]
          )
        )
      end
    end

    it "finds simple messages" do
      content = <<-EOF
        foo = __("xxxx")
      EOF

      with_file content do |path|
        expect(parser.parse(path, [])).to(
          eq(
            [
              ["xxxx", "#{path}:1"]
            ]
          )
        )
      end
    end

    it "finds messages with newlines/tabs" do
      content = <<-'EOF'
        bla = __("xxxx\n\tfoo")
      EOF

      with_file content do |path|
        expect(parser.parse(path, [])).to(
          eq(
            [
              ["xxxx\\n\\tfoo", "#{path}:1"]
            ]
          )
        )
      end
    end

    it "finds messages with newlines/tabs (single quotes)" do
      content = <<-'EOF'
        bla = __('xxxx\n\tfoo')
      EOF

      with_file content do |path|
        expect(parser.parse(path, [])).to(
          eq(
            [
              ["xxxx\\n\\tfoo", "#{path}:1"]
            ]
          )
        )
      end
    end

    it "finds messages with newlines/tabs (backticks)" do
      content = <<-'EOF'
        bla = __(`xxxx\n\tfoo`)
      EOF

      with_file content do |path|
        expect(parser.parse(path, [])).to(
          eq(
            [
              ["xxxx\\n\\tfoo", "#{path}:1"]
            ]
          )
        )
      end
    end

    it "finds interpolated multi-line messages" do
      content = <<-'EOF'
        """ Parser should grab
          #{ __("This") } __("known bug")
        """
      EOF

      with_file content do |path|
        expect(parser.parse(path, [])).to(
          eq(
            [
              ["This", "#{path}:2"],
              ["known bug", "#{path}:2"]
            ]
          )
        )
      end
    end

    it "finds strings that use some templating" do
      content = <<-EOF
        __("hello {yourname}")
      EOF

      with_file content do |path|
        expect(parser.parse(path, [])).to(
          eq(
            [
              ["hello {yourname}", "#{path}:1"]
            ]
          )
        )
      end
    end

    it "finds strings that use escaped strings" do
      content = <<-'EOF'
        __("hello \"dude\"") + __('how is it \'going\' ') +
        __('stellar "dude"') + __("it's 'going' good")
      EOF

      with_file content do |path|
        expect(parser.parse(path, [])).to(
          eq(
            [
              ["hello \\\"dude\\\"", "#{path}:1"],
              ["how is it 'going' ", "#{path}:1"],
              ["stellar \\\"dude\\\"", "#{path}:2"],
              ["it's 'going' good", "#{path}:2"]
            ]
          )
        )
      end
    end

    it "finds multi-line translations" do
      content = <<-EOF
        """ Parser should grab
        __(`Hello, my name is <span class="name">John Doe</span>
          and this is a very long string`)
        """
      EOF

      with_file content do |path|
        expect(parser.parse(path, [])).to(
          eq(
            [
              ["Hello, my name is <span class=\\\"name\\\">John Doe</span> and this is a very long string", "#{path}:2"]
            ]
          )
        )
      end
    end

    it "does not capture a false positive" do
      content = <<-EOF
        bla = should_not_be_registered__("xxxx", "yyyy")
      EOF

      with_file content do |path|
        expect(parser.parse(path, [])).to(
          eq(
            []
          )
        )
      end
    end

    it "does not find nonstring messages" do
      content = <<-EOF
        bla = __(bar)
      EOF

      with_file content do |path|
        expect(parser.parse(path, [])).to(
          eq(
            []
          )
        )
      end
    end

    it "does not parse internal parentheses" do
      content = <<-EOF
        bla = __("some text (great) and parentheses()") + __('foobar')
      EOF

      with_file content do |path|
        expect(parser.parse(path, [])).to(
          eq(
            [
              ["some text (great) and parentheses()", "#{path}:1"],
              ["foobar", "#{path}:1"]
            ]
          )
        )
      end
    end

    it "does not parse internal functions" do
      content = <<-EOF
        bla = n__("items (single)", "i (more)", item.count()) + __('foobar')
      EOF

      with_file content do |path|
        expect(parser.parse(path, [])).to(
          eq(
            [
              ["items (single)\000i (more)", "#{path}:1"],
              ["foobar", "#{path}:1"]
            ]
          )
        )
      end
    end

    it "does not parse empty files" do
      content = ""

      with_file content do |path|
        expect(parser.parse(path, [])).to(
          eq([])
        )
      end
    end
  end

  describe "parses vue files" do
    let(:example) do
      File.expand_path(
        "../../fixtures/example.vue",
        __dir__
      )
    end

    let(:parsed_example) do
      parser.parse(example, [])
    end

    it "parses all translations" do
      expect(parsed_example).to(
        eq(
          [
            ["Hello\\nBuddy", "#{example}:7"],
            ["json", "#{example}:18"],
            ["item\u0000items", "#{example}:19"]
          ]
        )
      )
    end

    it "accepts changing the translate method" do
      parser.gettext_function = "gettext"

      content = <<-'EOF'
        var string = \"this\" + gettext('json') + 'should be translated';
      EOF

      with_file content do |path|
        expect(parser.parse(path, [])).to(
          eq(
            [
              ["json", "#{path}:1"]
            ]
          )
        )
      end

      parser.gettext_function = "__"
    end
  end

  describe "parses javascript files" do
    let(:example) do
      File.expand_path(
        "../../fixtures/example.js",
        __dir__
      )
    end

    let(:parsed_example) do
      parser.parse(example, [])
    end

    it "parses all translations" do
      expect(parsed_example).to(
        eq(
          [
            ["json", "#{example}:2"],
            ["item\000items", "#{example}:3"],
            ["Hello {yourname}", "#{example}:6"],
            ["new-trans", "#{example}:9"],
            ["namespaced\004trans", "#{example}:10"],
            ["Hello\\nBuddy", "#{example}:11"]
          ]
        )
      )
    end

    it "accepts changing the translate method" do
      parser.gettext_function = "gettext"

      content = <<-'EOF'
        <template><div>{{ gettext('name') }}</div></template>
        <script>var string = \"this\" + gettext('json') + 'should be translated';</script>
      EOF

      with_file content do |path|
        expect(parser.parse(path, [])).to(
          eq(
            [
              ["name", "#{path}:1"],
              ["json", "#{path}:2"]
            ]
          )
        )
      end

      parser.gettext_function = "__"
    end
  end

  describe "parses coffee files" do
    let(:example) do
      File.expand_path(
        "../../fixtures/example.coffee",
        __dir__
      )
    end

    let(:parsed_example) do
      parser.parse(example, [])
    end

    it "parses all translations" do
      expect(parsed_example).to(
        eq(
          [
            ["json", "#{example}:2"],
            ["item\000items", "#{example}:3"],
            ["Hello {yourname}", "#{example}:5"],
            ["new-trans", "#{example}:8"],
            ["namespaced\004trans", "#{example}:9"],
            ["Hello\\nBuddy", "#{example}:11"],
            ["Multi-line", "#{example}:14"]
          ]
        )
      )
    end

    it "accepts changing the translate method" do
      parser.gettext_function = "gettext"

      content = <<-'EOF'
        string = \"this\" + gettext('json')

        object =
          one: ngettext('new-trans')
      EOF

      with_file content do |path|
        expect(parser.parse(path, [])).to(
          eq(
            [
              ["json", "#{path}:1"],
              ["new-trans", "#{path}:4"]
            ]
          )
        )
      end

      parser.gettext_function = "__"
    end
  end
end
