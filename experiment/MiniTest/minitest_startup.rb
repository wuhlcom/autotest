# gem 'minitest'
# require 'minitest/autorun'
# require "minitest/reporters"
#
# module WebFrame
# 	def startup(&block)
# 		block.call
# 	end
#
# 	def shutdown(&block)
# 		block.call
# 	end
# end
#
# class MiniTest::Unit::TestCase
# 	def run runner
# 		trap "INFO" do
# 			time = runner.start_time ? Time.now - runner.start_time : 0
# 			warn "%s#%s %.2fs" % [self.class, self.__name__, time]
# 			runner.status $stderr
# 		end if SUPPORTS_INFO_SIGNAL
#
# 		result = ""
# 		begin
# 			@passed = nil
# 			self.setup
# 			self.run_setup_hooks
# 			self.__send__ self.__name__
# 			result  = "." unless io?
# 			@passed = true
# 		rescue *PASSTHROUGH_EXCEPTIONS
# 			raise
# 		rescue Exception => e
# 			@passed = false
# 			result  = runner.puke self.class, self.__name__, e
# 		ensure
# 			begin
# 				self.run_teardown_hooks
# 				self.teardown
# 			rescue *PASSTHROUGH_EXCEPTIONS
# 				raise
# 			rescue Exception => e
# 				result = runner.puke self.class, self.__name__, e
# 			end
# 			trap 'INFO', 'DEFAULT' if SUPPORTS_INFO_SIGNAL
# 		end
# 		result
# 	end
# end
# class MiniTestStarup < MiniTest::Unit::TestCase
# 	i_suck_and_my_tests_are_order_dependent!
# 	# Called before every ftp_test method runs. Can be used
# 	# to set up fixture information.
# 	def self.startup
# 		p __method__
# 	end
#
# 	def self.shutdown
# 		p __method__
# 	end
#
# 	begin
# 		startup
#
# 		def setup
# 			p __method__
# 			# Do nothing
# 		end
#
# 		def test_1
# 			p __method__
# 			assert_equal 1, 2, "11111111111111111111111"
# 		end
#
# 		# def test_2
# 		#   assert_equal 1, 3, "222222222222222222222222"
# 		# end
# 		#
# 		# def test_3
# 		#   assert_equal 1, 4, "3333333333333333333333333"
# 		# end
# 		#
# 		# def test_4
# 		#   assert_equal 1, 5, "4444444444444444444444444"
# 		# end
#
# 		# def test_5
# 		# 	p __method__
# 		# 	assert 1, "555555555555555555555"
# 		# end
#
# 		# Called after every ftp_test method runs. Can be used to tear
# 		# down fixture information.
#
# 		def teardown
# 			# Do nothing
# 			p __method__
# 		end
#
#
# 	rescue => e
# 		p e
# 	ensure
# 		shutdown
# 	end
# # 	p MiniTest::Unit.runner
# end
