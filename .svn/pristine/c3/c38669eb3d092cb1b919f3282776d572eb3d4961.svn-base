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