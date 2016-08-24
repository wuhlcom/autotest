module A
		def send_cmd
				"1111"
		end

		def a_method1
				@param=1
		end
end

module B
		def send_cmd
				"22222"
		end

		def b_method0
				@param
		end
		# def b_method1
		# 		@param=2
		# end

		def b_method2
				# b_method1
				@param==2
		end
end

class Module_class
		include A
		include B
end
p obj = Module_class.new
p obj.a_method1
p obj.b_method0
p obj.b_method2
