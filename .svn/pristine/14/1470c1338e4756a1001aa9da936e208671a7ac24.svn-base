#encoding: utf-8
# gem 'minitest'
# require 'minitest/autorun'
p file_path =File.expand_path('../../lib/htmltags', __FILE__)
require file_path
# require 'htmltags'

# class Ping
#   include HtmlTag::WinCmd
#   include HtmlTag::Reporter
# end

class Test<MiniTest::Unit::TestCase
	include HtmlTag::WinCmd
	include HtmlTag::Reporter


	def test_ping
		ip = "192.168.111.1"
		# ip = "www.sina.com"
		p ping_recover(ip)
	end

# 	def testping_recover
# 		ip = "192.168.100.1"
# 		# ip = "www.sina.com"
# 		p ping_recover(ip)
# 	end
end