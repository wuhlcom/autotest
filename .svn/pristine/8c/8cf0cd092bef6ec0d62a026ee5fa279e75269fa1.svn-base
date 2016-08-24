#encoding:utf-8
gem 'minitest'
require "time"
require 'minitest/autorun'
file_path =File.expand_path('../../lib/htmltags', __FILE__)
require file_path
# require 'htmltags'
class MyTestIpconfig < MiniTest::Unit::TestCase
	include HtmlTag::WinCmd
	include HtmlTag::Reporter
	require 'pp'
	# stdio("ipconfig_test.log")
	i_suck_and_my_tests_are_order_dependent! #alpha，按顺序执行
	# Called before every ftp_test method runs. Can be used
	# to set up fixture information.
	def setup
		# Do nothing
	end

	def test_ipconfig_all
		# pp rs = ipconfig("all")
		# t = rs["dut"][:rent_time]
		# t2 = rs["dut"][:lease_time]
		# # t="20150916174946"
		# p s= Time.parse(t)
		# p s2=Time.parse(t2)
		# p s2-s
		# p s-s2
		p	get_host_name
		# pp ipconfig("all")["dut"][:mac].gsub("-",":")
	end

	def testipconfig
		@tc_dhcp_args

		p ipconfig

	end

	def testip_release
		@tc_dhcp_args ={nicname: "dut", source: "dhcp"}
		netsh_if_ip_setip(@tc_dhcp_args)
		pp ip_release("dut")
	end

	def testip_renew
		pp ip_renew("dut")
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