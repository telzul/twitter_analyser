var system = require('system');
var args = system.args;

var page = require('webpage').create();

page.settings.userAgent = 'Mozilla/5.0 (Windows NT 6.3; rv:36.0) Gecko/20100101 Firefox/36.0';

page.open(args[1], function(status) {
  if (status !== 'success') {
    phantom.exit(-1)
  } else {
      var shortname = page.evaluate(function () {
          return window.disqus_shortname
      });

      var identifier = page.evaluate(function () {
          return window.disqus_identifier
      });

      console.log(shortname);
      console.log(identifier);
      phantom.exit();
  }
});