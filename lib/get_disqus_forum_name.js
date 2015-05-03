var system = require('system');
var args = system.args;

var page = require('webpage').create();

page.settings.userAgent = 'Mozilla/5.0 (Windows NT 6.3; rv:36.0) Gecko/20100101 Firefox/36.0';

page.open(args[1], function(status) {
  if (status !== 'success') {
    phantom.exit(-1)
  } else {
      page.includeJs("http://ajax.googleapis.com/ajax/libs/jquery/1.6.1/jquery.min.js", function() {
        setTimeout(function(){
            var shortname = page.evaluate(function () {
              return JSON.parse($("#dsq-2").contents().find("#disqus-threadData").contents()["0"]["data"])["response"]["posts"][0]["thread"];
                            
              //return data//["response"];//.first["thread"]
            });

            console.log(shortname);
            phantom.exit();
        },10000);
    });
  }
});
