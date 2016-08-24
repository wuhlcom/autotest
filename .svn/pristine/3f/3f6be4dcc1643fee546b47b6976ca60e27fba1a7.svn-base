# #encoding:utf-8
require "execjs"
require "open-uri"
require 'pp'
#
# p ExecJS.eval "'red yellow blue'.split(' ')"
# # => ["red", "yellow", "blue"]
#
# source = open("http://coffeescript.org/extras/coffee-script.js").read
# p source.class
# context = ExecJS.compile(source)
# p context.call("CoffeeScript.compile", "square = (x) -> x * x", bare: true)
# => "var square;\nsquare = function(x) {\n  return x * x;\n};"

# context = ExecJS.compile "var run = function(foo) { return foo + foo }"
# context.call 'run', 'bar' #=> "barbar"
p dirname = File.dirname(__FILE__)
f2     ="#{dirname}/js/rsa.js"
f3     ="#{dirname}/js/BigInt.js"
f4     ="#{dirname}/js/Barrett.js"
f5     ="#{dirname}/js/func.js"
files  = [f2, f3, f4, f5]
contex =""
files.each do |file|
  content = File.open(file).read
  contex<<content
end
contexobj = ExecJS.compile(contex)
# contexobj = ExecJS.eval(contex)
# contexobj = ExecJS.exec(contex)
p contexobj.call 'encry', "123456"