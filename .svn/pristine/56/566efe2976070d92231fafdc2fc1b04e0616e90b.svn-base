#encoding:utf-8
gem 'minitest'
require 'minitest/autorun'
p file_path =File.expand_path('../../lib/htmltags', __FILE__)
require file_path
# require 'htmltags'

class MyTestNetshIF < MiniTest::Unit::TestCase
	include HtmlTag::WinCmd
	include HtmlTag::Reporter
	# stdio("netsh.log")
	i_suck_and_my_tests_are_order_dependent! #alpha，按顺序执行
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

	def testnetsh_if_shif
		# netsh_if_shif(args="")
		p netsh_if_shif()
		p netsh_if_shif("dut")
	end

	def testsetif_admin
		nic_name="local"
		nic_name="我"
		state   ="enabled"
		# state="disabled"
		p netsh_if_setif_admin(nic_name, state)
	end

	def testnet_if_ip_show_config
		args={nicname: "dut"}
		p net_if_ip_show(args)
	end

	# def test_net_if_ip_show_addresses
	def test_net
		args={nicname: "dut", type: "addresses"}
		rs = netsh_if_ip_show(args)
		p rs
	end

	def testnet_if_ip_show_dnsservers
		args={nicname: "wireless", type: "dnsservers"}
		p net_if_ip_show(args)
		# netsh_if_ip_show(nicname: @ts_nicname, type: "addresses")
	end

	def testnetsh_if_ip_setip_dhcp
		# nic_name = args[:nicname]
		# nic_name_gbk=nic_name.encode("GBK")
		# source = args[:source]
		# ip_adrr = args[:ip]
		# mask = args[:mask]
		# gw = args[:gateway]
		args={nicname: "wireless", source: "dhcp"}
		p netsh_if_ip_setip(args)
	end

	def testnetsh_if_ip_setip_static
		# args={nicname: "wireless", source: "static", ip: "100.0.0.2", mask: "255.255.255.0", gateway: "100.0.0.1"}
		args={nicname: "dut", source: "static", ip: "192.168.111.2", mask: "255.255.255.0"}
		args={nicname: "dut", source: "dhcp"}
		p netsh_if_ip_setip(args)
		# sleep 10
		#  p ipconfig
		# print `ipconfig`
	end

	def testip_renew
		p ip_renew("dut")
	end
	# Fake ftp_test
	# def test_fail
	#
	#   fail('Not implemented')
	# end
end