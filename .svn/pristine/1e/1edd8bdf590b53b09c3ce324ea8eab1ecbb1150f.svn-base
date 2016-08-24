#encoding:utf-8
gem 'minitest'
require 'minitest/autorun'

# file_path =File.expand_path('../../lib/htmltags', __FILE__)
# require file_path
require 'htmltags'
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

	def testgbk
		s1 = "中国"
		s1 =s1.to_gbk
		p s1_coding=s1.encoding.to_s
		assert_equal "GBK", s1_coding, "111111111111111"
	end

	def testutf8
		s1 = "条件"
		s1 =s1.to_utf8
		p s1_coding=s1.encoding.to_s
		assert_equal "UTF-8", s1_coding, "22222222222222"
	end

	def test_float
		# p t = "180000000000".to_f/1024/1024
		t =171661.355953125
		p t.roundf(2)
		p t.roundn(-2)
	end
	# Fake ftp_test
	# def test_fail
	#
	#   fail('Not implemented')
	# end
end