def method1
		"method1"

		def method2
				'method2'

				def method3
						'method3'
				end
		end
end

# p method1.method2.method3

class Test1
		define_method :method1 do |x| #动态定义方法
				x
		end
end
t1 = Test1.new
t1.method1
p t1.send :method1, 2 #动态派发方法
