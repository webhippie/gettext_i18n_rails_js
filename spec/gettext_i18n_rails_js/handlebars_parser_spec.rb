require "spec_helper"
require "gettext_i18n_rails_js/handlebars_parser"

describe GettextI18nRailsJs::HandlebarsParser do
  let(:parser){ GettextI18nRailsJs::HandlebarsParser }

  describe "#target?" do
    it "targets .handlebars" do
      parser.target?('foo/bar/xxx.handlebars').should == true
    end

    it "targets .handlebars.erb" do
      parser.target?('foo/bar/xxx.handlebars.erb').should == true
    end

    it "does not target cows" do
      parser.target?('foo/bar/xxx.cows').should == false
    end
  end

  describe "#parse" do
    it "finds messages in handlebars" do
      with_file '<div>{{_ "blah"}}' do |path|
        parser.parse(path, []).should == [
          ["blah", "#{path}:1"]
        ]
      end
    end

    it "finds plural messages in coffee" do
      with_file '<div>{{n_ "xxxx" "yyyy" "zzzz" some_count}}' do |path|
        parser.parse(path, []).should == [
          ["xxxx\000yyyy\000zzzz", "#{path}:1"]
        ]
      end
    end

    it "finds namespaced messages in handlebars" do
      with_file '<div>{{_ "xxxx", "yyyy"}}' do |path|
        parser.parse(path, []).should == [
          ["xxxx\004yyyy", "#{path}:1"]
        ]
      end
    end

    # it "does not capture a false positive with functions ending like the gettext function" do
    #   with_file 'bla = this_should_not_be_registered__("xxxx", "yyyy")' do |path|
    #     parser.parse(path, []).should == []
    #   end
    # end
    
    # it 'Does find messages in interpolated multi-line strings' do
    #   source = '''
    #     """ Parser should grab
    #       #{ __(\'This\') } __(\'known bug\')
    #     """
    #   '''
    #   with_file source do |path|
    #     parser.parse(path, []).should == [
    #       ["This", "#{path}:1"],
    #       ["known bug", "#{path}:1"]
    #     ]
    #   end
    # end
    
    # it 'finds messages with newlines and tabs in them' do
    #   with_file 'bla = __("xxxx\n\t")' do |path|
    #     parser.parse(path, []).should == [
    #       ['xxxx\n\t', "#{path}:1"]
    #     ]
    #   end
    # end

    it 'does not find messages that are not strings' do
      with_file '<div>{{_ bar}}' do |path|
        parser.parse(path, []).should == []
      end
    end

    it 'does not parse internal parentheses ' do
      with_file '<div>{{_ "some text (which is great) and some parentheses()"}}{{_ "foobar"}}' do |path|
        parser.parse(path, []).should == [
          ['some text (which is great) and some parentheses()', "#{path}:1"],
          ['foobar', "#{path}:1"]
        ]
      end
    end

    # it 'does not parse internal called functions' do
    #   with_file 'bla = n__("items (single)", "items (more)", item.count()) + __(\'foobar\')' do |path|
    #     parser.parse(path, []).should == [
    #       ["items (single)\000items (more)", "#{path}:1"],
    #       ['foobar', "#{path}:1"]
    #     ]
    #   end
    # end

    # it 'finds messages with newlines and tabs in them (single quotes)' do
    #   with_file "bla = __('xxxx\\n\\t')" do |path|
    #     parser.parse(path, []).should == [
    #       ['xxxx\n\t', "#{path}:1"]
    #     ]
    #   end
    # end
    # it 'finds strings that use some templating' do
    #   with_file '__("hello {yourname}")' do |path|
    #     parser.parse(path, []).should == [
    #       ['hello {yourname}', "#{path}:1"]
    #     ]
    #   end
    # end
    # it 'finds strings that use escaped strings' do
    #   with_file '__("hello \"dude\"") + __(\'how is it \\\'going\\\' \')' do |path|
    #     parser.parse(path, []).should == [
    #       ['hello \"dude\"', "#{path}:1"],
    #       ["how is it \\'going\\' ", "#{path}:1"]
    #     ]
    #   end
    # end
    # it 'accepts changing the function name' do
    #   GettextI18nRailsJs::HandlebarsParser.js_gettext_function = 'gettext'
    #   with_file 'gettext("hello {yourname}") + ngettext("item", "items", 44)' do |path|
    #     parser.parse(path, []).should == [
    #       ['hello {yourname}', "#{path}:1"],
    #       ["item\000items", "#{path}:1"],
    #     ]
    #   end
    #   GettextI18nRailsJs::HandlebarsParser.js_gettext_function = '__'
    # end
  end
  
  describe 'mixed use tests' do
    it 'parses a full handlebars file' do
      result = parser.parse(File.join(File.dirname(__FILE__), '../fixtures/example.handlebars'),[])
      result.collect(&:first).should == ["Locale", "Profile", "Update\004Updates"]
      result.collect(&:last).each do |path|
        path.should be_end_with("fixtures/example.handlebars:1")
      end
    end
  end
end
