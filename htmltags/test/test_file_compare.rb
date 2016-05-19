#encoding:utf-8
gem 'minitest'
require 'minitest/autorun'
# file_path =File.expand_path('../../lib/htmltags', __FILE__)
# require file_path
require 'htmltags'
module Frame
	class MyTestString < MiniTest::Unit::TestCase
		# Called before every ftp_test method runs. Can be used
		# to set up fixture information.
		def setup
			# Do nothing
		end

		# Called after every ftp_test method runs. Can be used to tear
		# down fixture information.

		def teardown
			# Do nothing
		end

		def test_compare
			f1 = "ipconfig_test.rb"
			f2 = "loginout_test.rb"
		p	HtmlTag::FileCompare.cmp2file(f1,f2)
		end
		# Fake ftp_test
		# def test_fail
		#
		#   fail('Not implemented')
		# end
	end
end