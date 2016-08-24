def getBinding(str)
  return binding()
end
str = "hello"
puts( eval( "str + ' Fred'" )   )                                #=> "hello Fred"
#str与getBinding方法的参数名要保持一致
puts( eval( "str + ' Fred'", getBinding("bye") ) )              #=> "bye Fred"
puts( eval( "str + ' Fred'", binding) )              #=> "bye Fred"

# class MyClass
#   @@x = " x"
#   def initialize(s)
#     @mystr = s
#   end
#   def getBinding
#     return binding()
#   end
# end
#
# class MyOtherClass
#   @@x = " y"
#   def initialize(s)
#     @mystr = s
#   end
#   def getBinding
#     return binding()
#   end
# end
# p binding
# p @mystr = self.inspect
# @@x = " some other value"
#
# ob1 = MyClass.new("ob1 string")
# ob2 = MyClass.new("ob2 string")
# ob3 = MyOtherClass.new("ob3 string")
# puts(eval("@mystr << @@x", ob1.getBinding))  #=> ob1 string x
# puts(eval("@mystr << @@x", ob2.getBinding))  #=> ob2 string x
# puts(eval("@mystr << @@x", ob3.getBinding))  #=> ob3 string y
# puts(eval("@mystr << @@x", binding))             #=> main some other value


