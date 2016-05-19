#encoding:utf-8
gem 'minitest'
require 'minitest/autorun'

file_path =File.expand_path('../../lib/htmltags', __FILE__)
require file_path
# require 'htmltags'
class Wireshark < MiniTest::Unit::TestCase
		include HtmlTag::WinCmd
		include HtmlTag::Wireshark
		include HtmlTag::WinCmdSys
		include HtmlTag::Reporter
		require 'pp'
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

		def testlocalcap
				pc_mac = ipconfig("all")["dut"][:mac].gsub("-", ":")
				url    = "www.baidu.com"
				begin
						thr      = Thread.new { ping(url, 200) }
						filter   = "ether src host #{pc_mac} and icmp"
						file_path= "d:/test_local.pcap"
						dumpcap_a(file_path, "dut", 10, filter)
						packets = capinfos(file_path)
						assert(packets.to_i>0, "2222")
				rescue => e
						puts e.message.to_s
				ensure
						# p "11111111"
						thr.kill if thr.alive?
				end
				# p "22222222222222222222"
		end


		def testlocal_tshark
				# tc_cap_fields = "-e eth.dst -e eth.src -e ip.src -e ip.dst -e bootp.option.type -e bootp.option.ip_address_lease_time"
				# tc_cap_filter = "bootp.option.type==51"

				tc_cap_fields = "-e eth.dst -e eth.src -e ip.src -e ip.dst"
				tc_cap_filter = "ip.addr==192.168.100.100"
				puts "Capture filter: #{tc_cap_filter}"
				@ts_nicname   ="dut"
				@tc_lease_time="10"
				args          ={nic: @ts_nicname, filter: tc_cap_filter, duration: @tc_lease_time, fields: tc_cap_fields}
				p rs = tshark_display_filter_fields(args)
				# 	p	`tshark -ni "dut" -Y "ip.addr==192.168.100.100" -T "fields" -a "duration:10" -e ip.src -e ip.dst`
		end

		def testtshark_remote
				DRb.start_service
				@ts_drb_server2 = "druby://50.50.50.57:8787"
				@tc_dumpcap     = DRbObject.new_with_uri(@ts_drb_server2)
				# tc_cap_fields = "-e eth.dst -e eth.src -e ip.src -e ip.dst -e bootp.option.type -e bootp.option.ip_address_lease_time"
				# tc_cap_filter = "bootp.option.type==51"

				tc_cap_fields   = "-e eth.dst -e eth.src -e ip.src -e ip.dst"
				tc_cap_filter   = "ip.addr==10.10.10.65"
				puts "Capture filter: #{tc_cap_filter}"
				@ts_nicname   = "lan"
				@tc_lease_time= "10"
				args          ={nic: @ts_nicname, filter: tc_cap_filter, duration: @tc_lease_time, fields: tc_cap_fields}
				p rs = @tc_dumpcap.tshark_display_filter_fields(args)
		end

		def test_remotecap
				DRb.start_service
				@ts_drb_server2 = "druby://50.50.50.57:8787"
				@tc_dumpcap     = DRbObject.new_with_uri(@ts_drb_server2)
				# pc_mac          = ipconfig("all")["dut"][:mac].gsub("-", ":")
				pc_mac          = "78:A3:51:03:9E:99"
				# pc_mac          = "00:11:00:00:00:01"
				url             = "www.baidu.com"
				url             = "10.10.10.1"
				nic             = "LAN"
				captime         = 5
				pingnum         = 300
				filter          = "ether src host #{pc_mac} and icmp"
				filter          = "ether src host #{pc_mac} "
				file_path       = "d:/captures/mac_clone_dhcp_pc.pcap"

		p		file_name = File.basename(file_path, ".*")
				# begin
				# 		thr = Thread.new { ping(url, pingnum) }
				# 		sleep 2
			p	 		@tc_dumpcap.dumpcap_a(file_path, nic, captime, filter)
				# 		p packets= @tc_dumpcap.capinfos(file_path)
				# 		assert(packets.to_i>0)
				# rescue => e
				# 		puts e.message.to_s
				# ensure
				# 		p "111111"
				# 		p thr.alive?
				# 		thr.kill if thr.alive?
				# 		p "2222222"
				# 		p tasklist_exists?("ping.exe")
				# 		p taskkill("ping.exe")
				# end

		end


		# Fake ftp_test
		# def test_fail
		#
		#   fail('Not implemented')
		# end
end