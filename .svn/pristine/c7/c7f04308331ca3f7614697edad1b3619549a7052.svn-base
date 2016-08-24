#encoding:utf-8
#require 'htmltags'
gem 'minitest'
require 'minitest/autorun'
require 'watir-webdriver'

class MyTestArtDialog < MiniTest::Unit::TestCase
	i_suck_and_my_tests_are_order_dependent! #alpha，按顺序执行
	#
	# include HtmlTag::WinCmd
	# include HtmlTag::Reporter
	# include HtmlTag::LogInOut
	def setup
		# Do nothing
	end

	def testwait_until
		x = 10
		Watir::Wait.until(10, "超时了") {
			# p Time.now().strftime("%Y %m %qos %H %M %S")
			x==11
		}

		at_exit {
			p "at_exit "*10
			p Time.now().strftime("%Y %m %qos %H %M %S")
		}
	end

	def test_wait_while
		x = 10
		p Time.now().strftime("%Y %m %qos %H %M %S")
		w = Watir::Wait.while(10, "超时了") {
			p Time.now().strftime("%Y %m %qos %H %M %S")
			x==10
		}
		p w
		at_exit {
			p "at_exit "*10
			p Time.now().strftime("%Y %m %qos %H %M %S")
		}

	end

	# Called after every ftp_test method runs. Can be used to tear
	# down fixture information.

	def teardown
		# Do nothing
	end

	# Fake ftp_test
	# def test_fail
	#
	#   fail('Not implemented')
	# end
end