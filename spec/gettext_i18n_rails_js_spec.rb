require "spec_helper"
require_relative '../lib/gettext_i18n_rails_js/version'

describe GettextI18nRailsJs do
  it "has a VERSION" do
    GettextI18nRailsJs::VERSION.should =~ /^\d+\.\d+\.\d+$/
  end
  
  it "finds translations in the dummy app" do
    `cd spec/dummy && rake gettext:find && rake gettext:po_to_json`
    $?.should be_success
  end
end
