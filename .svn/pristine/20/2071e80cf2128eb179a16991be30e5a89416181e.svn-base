#encoding: utf-8
gem 'minitest'
require 'minitest'
require 'minitest/unit'
require 'minitest/assertions'
require 'minitest/autorun'
file_path =File.expand_path('../../lib/htmltags', __FILE__)
require file_path
# require 'htmltags'


class Test<MiniTest::Unit::TestCase
	include HtmlTag::WinCmd
	include HtmlTag::Reporter
	def testmodule_ping
		# Ping.stdio("ping.log")
		stdio("ping.log")
		uri="www.baidu.com"
		# uri="111"
		assert HtmlTag::WinCmd.ping(uri),"ping失败"
		# assert ping(uri),"ping失败"
	end


	def testping
		ip = "192.168.111.1"
		ping(ip)
	end

	def test_aaa
		x=1
		y=2
		assert_block
		assert_block("111"){
			x==y
		}
	end

end