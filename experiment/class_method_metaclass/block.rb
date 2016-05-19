class T
		# attr_accessor :read
		# attr_accessor :access
		# attr_writer :write

		def initialize(read, write, access)
				@read  = read
				@write = write
				@access= access
		end

		# def access
		# 		@access
		# end
		#
		# def access=(x)
		# 		@access=x
		# end

		def test
		@read+=1
		end

		def test2
				@read=100
		end
end
t1 = T.new(1,2,3)
t1.read=100
t1.test
t1.test2