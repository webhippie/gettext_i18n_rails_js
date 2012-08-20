# GettextI18nRailsJs

GettextI18nRailsJs extends [gettext_i18n_rails](https://github.com/grosser/gettext_i18n_rails) making your .po files available to client side javascript as JSON

It will find translations inside your .js and .coffee files, then it will create JSON versions of your .PO files so you can serve them with the rest of your assets, thus letting you access all your translations offline from client side javascript.

## Installation

It requires rails 3.2 or later, any version of 'gettext_i18n_rails' will do though.

#### Add the following to your gemfile:

    gem 'gettext_i18n_rails_js'

## To convert your PO files into javascript files you can run:

    rake gettext:po_to_json

This will reconstruct the `locale/<lang>/app.po` structure as javascript files inside `app/assets/javascripts/locale/<lang>/app.js`

## Using this translations in your javascript

The gem provides the Jed library to use the generated javascript files. (http://slexaxton.github.com/Jed/some) 
It also provides a global `__` function that maps to `Jed#gettext`.
The Jed instance used by the client side `__` function is pre-configured with the 'lang' specified in your main html tag.
Before anything, make sure your page's html tag includes a valid 'lang' attribute, for example:

    %html{:manifest => '', :lang => "#{I18n.locale}"}

Once you're sure your page is configured with a locale, then you should add both your javascript locale files and the provided javascripts to your application.js

    //= require_tree ./locale 
    //= require gettext/all

## Avoiding conflicts with other libraries

The default function name is 'window.__', to avoid conflicts with 'underscore.js'. If you want to alias the function to something
else in your javascript you should also instruct the javascript and coffeescript parser to look for a different function
when finding your translations:

lib/tasks/gettext.rake:

    namespace :gettext do
      def js_gettext_function
        '_' #just revert to the traditional underscore.
      end
    end

