class MyClass
	def initialize
		@v=1
	end
end
p obj=MyClass.new
obj.instance_eval do
	self
	 @v
end
p obj
obj.instance_eval do
	 self
	 @v=2
end
p obj

class Test

end

# Test.instance_eval do
# 	eval(	"def method1
# puts '11'
# end
# "
# end

Test.instance_eval("def method1; puts '11';end")
p Test.method1