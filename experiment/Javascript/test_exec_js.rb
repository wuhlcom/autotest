#encoding:utf-8
require "execjs"
require "open-uri"
p source = open("http://coffeescript.org/extras/coffee-script.js").read
p source=source.encode("GBK")
p context = ExecJS.compile(source)
p context.call("CoffeeScript.compile", "square = (x) -> x * x", bare: true)
# => "var square;\nsquare = function(x) {\n return x * x;\n};"