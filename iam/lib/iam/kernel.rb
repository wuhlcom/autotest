module Kernel
		def rand_port(less=3000, max=65534)
				if less==max
						return less
				end
				port = 0
				loop do
						port = rand(max)
						break if port>less
				end
				port
		end

		def rand_not_spec(spec, max)
				if spec==max
						return "#{spec} shoud not equal self"
				end
				num = 0
				loop do
						num = rand(max)
						break if num != spec
				end
				num
		end

		def rand_not_spec_less(less, spec, max)
				if less==max
						return "#{less} should not equal self"
				end
				if spec==max || spec==less
						if spec==max
								return "#{spec} should not equal #{max}"
						elsif spec==less
								return "#{spec} should not equal #{less}"
						end
				end
				num = 0
				loop do
						num = rand(max)
						break if num != spec && num>less
				end
				num
		end
end

if __FILE__ == $0
		# p rand_not_spec_less(0,100,255)
end