#encoding:utf-8
require 'test/unit'

class MyTest2 < Test::Unit::TestCase

		# Called before every ftp_test method runs. Can be used
		# to set up fixture information.
		def setup
				# Do nothing
				p "MyTest2 setup"
		end

		# Called after every ftp_test method runs. Can be used to tear
		# down fixture information.

		def teardown
				p "MyTest2 teardown"
				# Do nothing
		end

		def test_method1
				p "#{self.to_s},method:#{__method__.to_s}"
				assert(true, "test2 failed")
		end

		def test_method2
				p "#{self.to_s},method:#{__method__.to_s}"
				assert(true, "test2 failed")
		end
		# Fake ftp_test
		# def test_fail
		#
		#   fail('Not implemented')
		# end
end