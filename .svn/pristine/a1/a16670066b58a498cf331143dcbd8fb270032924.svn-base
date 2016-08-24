require 'execjs'
context = ExecJS.compile "var run = function(foo) { return foo + foo }"
p context.class
p context.call 'run', 'bar' #=> "barbar"



# html = '<h1>JSDOM Homepage</h1>'
# jquery = 'http://code.jquery.com/jquery-1.5.min.js'
# jsdom.env(html, [jquery], function(errors, window) {
#   console.log("contents of a.the-link:", window.$("h1").text());
#   // logs: JSDOM Homepage
# });
ontext = ExecJS.compile <<-JAVASCRIPT
  var run = function(html, code){
    jsdom.env(html, [jquery], function(errors, window) {
      var jQuery = window.jQuery;
      var $ = jQuery;
      var document = window.document;
      eval(students_code);
      return window.jQuery('body').html();
    });
  }
JAVASCRIPT
require "execjs-async"
html         = "<h1>Foo</h1>"
student_code = "$('h1').text('Bar')"
p context.call 'run', html, student_code

context = ExecJS.compile_async <<-JAVASCRIPT
  var run = function(html, code){
    jsdom.env(html, [jquery], function(errors, window) {
      var jQuery = window.jQuery;
      var $ = jQuery;
      var document = window.document;
      eval(students_code);
      callback(window.jQuery('body').html());
    });
  }
JAVASCRIPT

html         = "<h1>Foo</h1>"
student_code = "$('h1').text('Bar')"
p context2.call 'run', html, student_code
# => "<h1>Bar</h1>"