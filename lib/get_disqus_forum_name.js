var system = require('system');
var args = system.args;
var fs = require('fs');
var page = require('webpage').create();
page.settings.userAgent = 'Mozilla/5.0 (Windows NT 6.3; rv:36.0) Gecko/20100101 Firefox/36.0';
page.open(args[1], function(status) {
	console.log(status);
  if (status !== 'success') {
    phantom.exit(-1);
  } else {
    setTimeout(function(){
	    page.includeJs("http://ajax.googleapis.com/ajax/libs/jquery/1.6.1/jquery.min.js", function() {
	        var data = page.evaluate(function () {
	        	d = {};
		        try {
		            d["forum_shortname"] = window.disqus_shortname;
		            d["thread_ident"] = window.disqus_identifier;
		        }catch(err){}
		        try {
		            d["thread_id"] = JSON.parse($('[id^=dsq-]').first().contents().find("#disqus-threadData").contents()["0"]["data"])["response"]["posts"][0]["thread"];
		        }catch(err){}
		        return d;
	        });
	        fs.write(args[2],JSON.stringify(data));
	        phantom.exit();
	    });
    },5000);
  }
});
