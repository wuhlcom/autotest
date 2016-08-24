#encoding:utf-8
gem 'minitest'
require 'minitest/autorun'

# file_path =File.expand_path('../../lib/htmltags', __FILE__)
# require file_path
require 'htmltags'
class MyTestString < MiniTest::Unit::TestCase
	include HtmlTag::WinCmdRoute
	include HtmlTag::WinCmd
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

	def test_route
		p @tc_ppptp_addr= "1.1.1.3"
		dst              = "1.1.1.0"
		mask             = "255.255.255.0"
		gw               = "10.10.10.1"
		# cmd_route_add(dst, mask, gw)
		# ip_info = netsh_if_ip_show(nicname: "control", type: "addresses")
		# ip_arr  =ip_info[:ip]
		# flag    = ip_arr.any? { |ip| ip=~/#{@ts_wan_client_ip}/ }
		# assert(flag, "未配置指定的ip地址#{@ts_wan_client_ip}")

	p	routes  = cmd_route_print()
		temp    = routes[:permanent].keys.any? { |net|
			 new_net = net.sub(/\d+$/, "")
			@tc_ppptp_addr=~/#{new_net}/
		}
		p temp
	end
	# Fake ftp_test
	# def test_fail
	#
	#   fail('Not implemented')
	# end
end