gem 'minitest'
require 'minitest/autorun'
require 'minitest/reporters'
class MiniTest_test < MiniTest::Unit::TestCase
# class MiniTest2 < MiniTest::Test
# Called before every ftp_test method runs. Can be used
# to set up fixture information.
		i_suck_and_my_tests_are_order_dependent!

		def before_setup
				p "#{__method__.to_s}"
		end

		def setup
				p "#{__method__.to_s}"
		end

		def test_2
				p "2"*10
				assert_equal 1, 1, "222"
		end

		def test_1
				p "1"*10
				assert_equal 1, 1, "1111111"
		end

		def test_3
				p "3"*10
				assert_equal 1, 1, "ccccccccccccccccccccccc"
		end

		#
		# def test_4
		# 		p "4"*10
		# 		assert_equal 1, 5, "dddddddddddddddddddd"
		# end
		#
		# def test_5
		# 		p "5"*10
		# 		assert_equal 1, 6, "eeeeeeeeeeeeeeeeeeeeeeeeeee"
		# end

		# Called after every ftp_test method runs. Can be used to tear
		# down fixture information.

		def teardown
				p "#{__method__.to_s}"
		end

# Fake ftp_test
# def test_fail
#
#   fail('Not implemented')
# end

end
# p MiniTest_test.new("test_1").run