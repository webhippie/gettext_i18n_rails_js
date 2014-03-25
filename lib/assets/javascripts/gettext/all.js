//= require ./jed 

(function(){ 
  locale = $('body').data('locale');

  if (!locale) {
    console.log("ATTENTION: data-locale is a required attribute on the BODY tag!");
    return;
  }

  var i18n = new Jed(locales[locale] || {});
  window.__ = function(){ return i18n.gettext.apply(i18n, arguments) };
  window.gettext = window.__;
  window.n__ = function(){ return i18n.ngettext.apply(i18n, arguments) };
  window.ngettext = window.n__;
  window.i18n = i18n;

  //adds scoping
  window.s__ = function(key) {
    return __(key).split('|').pop();
  }
})();
