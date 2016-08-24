#encoding:utf-8
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
module IAMAPI
  class JsEncry
    def self.encry(passwd)
      begin
        dirname = File.dirname(__FILE__)
        f1      ="#{dirname}/js/rsa.js"
        f2      ="#{dirname}/js/BigInt.js"
        f3      ="#{dirname}/js/Barrett.js"
        f4      ="#{dirname}/js/func.js"
        files   = [f1, f2, f3, f4]
        contex  =""
        files.each do |file|
          content = File.open(file).read
          contex<<content
        end
        contexobj = ExecJS.compile(contex)
        contexobj.call('encry', passwd)
      rescue => ex
        puts ex.message.tos
        puts "JavaScript encription failed!"
      end
    end
  end
end