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

require "spec_helper"

describe GettextI18nRailsJs::Parser::Handlebars do
  let(:parser) { GettextI18nRailsJs::Parser::Handlebars }

  describe "#target?" do
    it "targets .handlebars" do
      expect(parser.target?("foo/bar/xxx.handlebars")).to be_truthy
    end

    it "targets .handlebars.erb" do
      expect(parser.target?("foo/bar/xxx.handlebars.erb")).to be_truthy
    end
    it "targets .hbs" do
      expect(parser.target?("foo/bar/xxx.hbs")).to be_truthy
    end

    it "targets .hbs.erb" do
      expect(parser.target?("foo/bar/xxx.hbs.erb")).to be_truthy
    end

    it "targets .mustache" do
      expect(parser.target?("foo/bar/xxx.mustache")).to be_truthy
    end

    it "targets .mustache.erb" do
      expect(parser.target?("foo/bar/xxx.mustache.erb")).to be_truthy
    end

    it "does not target cows" do
      expect(parser.target?("foo/bar/xxx.cows")).to be_falsey
    end
  end

  describe "#parse" do
    it "finds plural messages" do
      content = <<-EOF
        <div>{{n_ "xxxx" "yyyy\" "zzzz" some_count}}</div>
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
        <div>{{_ "xxxx", "yyyy"}}</div>
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
        <div>{{_ "blah"}}</div>
      EOF

      with_file content do |path|
        expect(parser.parse(path, [])).to(
          eq(
            [
              ["blah", "#{path}:1"]
            ]
          )
        )
      end
    end

    # it "finds messages with newlines/tabs" do
    #   content = <<-EOF
    #     bla = __("xxxx\n\tfoo")
    #   EOF

    #   with_file content do |path|
    #     expect(parser.parse(path, [])).to(
    #       eq(
    #         [
    #           ["xxxx\n\tfoo", "#{path}:1"]
    #         ]
    #       )
    #     )
    #   end
    # end

    # it "finds messages with newlines/tabs (single quotes)" do
    #   content = <<-EOF
    #     bla = __('xxxx\n\tfoo')
    #   EOF

    #   with_file content do |path|
    #     parser.parse(path, []).should == [
    #       ["xxxx\n\tfoo", "#{path}:1"]
    #     ]
    #   end
    # end

    # it "finds interpolated multi-line messages" do
    #   content = <<-EOF
    #     """ Parser should grab
    #       #{ __("This") } __("known bug")
    #     """
    #   EOF

    #   with_file content do |path|
    #     expect(parser.parse(path, [])).to(
    #       eq(
    #         [
    #           ["This", "#{path}:3"],
    #           ["known bug", "#{path}:3"]
    #         ]
    #       )
    #     )
    #   end
    # end

    # it "finds strings that use some templating" do
    #   content = <<-EOF
    #     __("hello {yourname}")
    #   EOF

    #   with_file content do |path|
    #     expect(parser.parse(path, [])).to(
    #       eq(
    #         [
    #           ["hello {yourname}", "#{path}:1"]
    #         ]
    #       )
    #     )
    #   end
    # end

    # it "finds strings that use escaped strings" do
    #   content = <<-EOF
    #     __("hello \"dude\"") + __('how is it \'going\' ')
    #   EOF

    #   with_file content do |path|
    #     expect(parser.parse(path, [])).to(
    #       eq(
    #         [
    #           ["hello \"dude\"", "#{path}:1"],
    #           ["how is it 'going' ", "#{path}:1"]
    #         ]
    #       )
    #     )
    #   end
    # end

    # it "does not capture a false positive" do
    #   content = <<-EOF
    #     bla = this_should_not_be_registered__("xxxx", "yyyy")
    #   EOF

    #   with_file content do |path|
    #     expect(parser.parse(path, [])).to(
    #       eq(
    #         []
    #       )
    #     )
    #   end
    # end

    it "does not find nonstring messages" do
      content = <<-EOF
        <div>{{_ bar}}</div>
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
        <div>
          {{_ "text (which is great) and parentheses()"}}
          {{_ "foobar"}}
        </div>
      EOF

      with_file content do |path|
        expect(parser.parse(path, [])).to(
          eq(
            [
              ["text (which is great) and parentheses()", "#{path}:1"],
              ["foobar", "#{path}:1"]
            ]
          )
        )
      end
    end

    # it "does not parse internal functions" do
    #   content = <<-EOF
    #     bla = n__("items (single)", "i (more)", item.count()) + __('foobar')
    #   EOF

    #   with_file content do |path|
    #     parser.parse(path, []).should == [
    #       ["items (single)\000i (more)", "#{path}:1"],
    #       ['foobar', "#{path}:1"]
    #     ]
    #   end
    # end
  end

  describe "parses handlebars files" do
    let(:example) do
      File.expand_path(
        "../../../fixtures/example.handlebars",
        __FILE__
      )
    end

    let(:parsed_example) do
      parser.parse(example, [])
    end

    it "parses all translations" do
      expect(parsed_example.collect(&:first)).to(
        eq(["Locale", "Profile", "Update\004Updates"])
      )
    end

    it "parses the file paths" do
      parsed_example.collect(&:last).each do |path|
        expect(path).to end_with("fixtures/example.handlebars:1")
      end
    end

    it "accepts changing the translate method" do
      parser.handlebars_gettext_function = "gettext"

      content = <<-EOF
        <div>
          {{gettext \"Hello {yourname}\"}}
          <span>
            {{ngettext \"item\", \"items\", 44}}
          </span>
        </div>
      EOF

      with_file content do |path|
        expect(parser.parse(path, [])).to(
          eq(
            [
              ["Hello {yourname}", "#{path}:1"],
              ["item\000items", "#{path}:1"]
            ]
          )
        )
      end

      parser.handlebars_gettext_function = "__"
    end
  end
end
