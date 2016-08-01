#encoding:utf-8
gem 'minitest'
require 'minitest/autorun'
file_path =File.expand_path('../../lib/htmltags', __FILE__)
require 'pp'
require file_path
# require 'htmltags'
class MyTestRouterTelnet < MiniTest::Unit::TestCase
		include HtmlTag::Telnet
		include HtmlTag::RouterTelnet
		# stdio("netsh.log")
		# i_suck_and_my_tests_are_order_dependent! #alpha，按顺序执行
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

		def testuptime
				ip = "192.168.100.1"
				# telnet_init(ip, user="root", password="zl4321")
				# p exp_run_time(cmd="uptime")
				init_router_obj(ip, usr="root", pw="zl4321")
				p get_router_uptime(timeout=10)
		end

		def testtelnet
				ip = "192.168.100.1"
				telnet_init(ip, user="root", password="zl4321")
				# telnet_send_cmd("firstboot")
				#  sleep 1
				# telnet_send_cmd("y")
				# sleep 1
				t1 = Time.now
				exp_ralink_init
				t2 = Time.now
				p t2-t1
				p "1111"
		end

		def testiwconfig
				ip   = "192.168.90.1"
				intf = "eth0.2"
				init_router_obj(ip, usr="root", pw="zl4321")
				p router_iwconfig()
		end

		def testifconfig
				ip   = "192.168.100.1"
				intf = "eth0.22"
				init_router_obj(ip, usr="root", pw="zl4321")
				p router_ifconfig(intf)
				#路由器模式
				# str      = "ifconfig eth0.2\neth0.2    Link encap:Ethernet  HWaddr 10:22:33:22:33:11  \n          inet addr:10.10.10.20  Bcast:10.10.10.255  Mask:255.255.255.0\n          inet6 addr: fe80::1222:33ff:fe22:3311/64 Scope:Link\n          UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1\n          RX packets:1666 errors:0 dropped:0 overruns:0 frame:0\n          TX packets:467 errors:0 dropped:0 overruns:0 carrier:0\n          collisions:0 txqueuelen:0 \n          RX bytes:165611 (161.7 KiB)  TX bytes:45329 (44.2 KiB)\n\nroot@Console:~# "
				# #AP模式
				# str      = "ifconfig eth0.2\neth0.2    Link encap:Ethernet  HWaddr 10:22:33:22:33:10  \n          BROADCAST MULTICAST  MTU:1500  Metric:1\n          RX packets:1 errors:0 dropped:0 overruns:0 frame:0\n          TX packets:0 errors:0 dropped:0 overruns:0 carrier:0\n          collisions:0 txqueuelen:0 \n          RX bytes:78 (78.0 B)  TX bytes:0 (0.0 B)\n\nroot@Console:~# "
				# wan_info = {}
				# if str=~/inet\s+addr/i
				# 		arr = str.split("\n")
				# 		arr.each do |item|
				# 				if /inet\s+addr:\s*(?<ip>\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3})/i=~item
				# 						p wan_info[:ip]=ip
				# 				elsif /Ethernet\s+HWaddr\s+(?<mac>[\d+|a-f]{2}:[\d+|a-f]{2}:[\d+|a-f]{2}:[\d+|a-f]{2}:[\d+|a-f]{2}:[\d+|a-f]{2})/i=~item
				# 						p wan_info[:mac]=mac
				# 				end
				# 		end
				# else
				# 		/Ethernet\s+HWaddr\s+(?<mac>[\d+|a-f]{2}:[\d+|a-f]{2}:[\d+|a-f]{2}:[\d+|a-f]{2}:[\d+|a-f]{2}:[\d+|a-f]{2})/i=~str
				# 		p wan_info[:mac]=mac
				# end
		end

		def testps
				# udhcpc、udhcpd、lighttpd、dnsmasq、ntpd
				ip = "192.168.100.1"
				init_router_obj(ip, usr="root", pw="zl4321")
				rs = router_attack_ps("xxx")
				p rs
		end

		def test_powersw
				ip = "192.168.100.1"
				sw = "off"
				init_router_obj(ip, usr="root", pw="zl4321")
				rt_power_sw(sw)
		end

end