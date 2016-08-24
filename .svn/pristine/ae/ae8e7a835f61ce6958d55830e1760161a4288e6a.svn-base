# p Class.methods
# p Class.instance_methods(false)
# p Class.superclass
# p Module.superclass
# p Method.class
# p Method.instance_methods(false)

class Test
		@param1 = 2

		def m1
				@param1
		end

end
# p Test.new.m1
class Time_test
		def initialize
				@report_time = Time.new.strftime("%Y%m%d")
		end
end
class Sub<Time_test

		def  date
				@report_time
		end
end
 t =Sub.new.date
p "#{t}"