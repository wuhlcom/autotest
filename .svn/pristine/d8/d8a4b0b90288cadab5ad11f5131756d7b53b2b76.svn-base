#encoding:utf-8
gem 'minitest'
require 'minitest/autorun'

file_path =File.expand_path('../../lib/htmltags', __FILE__)
require file_path
# require 'htmltags'
class PingCap < MiniTest::Unit::TestCase
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
			file_path= "qos:/test_local.pcap"
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

	def test_remotecap
		DRb.start_service
		@ts_drb_server2 = "druby://10.10.10.57:8787"
		@tc_dumpcap     = DRbObject.new_with_uri(@ts_drb_server2)
		# pc_mac          = ipconfig("all")["dut"][:mac].gsub("-", ":")
		pc_mac          = "78:A3:51:03:9E:99"
		# pc_mac          = "00:11:00:00:00:01"
		url             = "www.baidu.com"
		url             = "10.10.10.1"
		nic             = "LAN"
		captime         = 10
		pingnum         = 300
		filter          = "ether src host #{pc_mac} and icmp"
		filter          = "ether src host #{pc_mac} "
		file_path       = "qos:/ftp_test/test_remote_pppoe.pcap"
		begin
			thr = Thread.new { ping(url, pingnum) }
			sleep 2
			@tc_dumpcap.dumpcap_a(file_path, nic, captime, filter)
			p packets= @tc_dumpcap.capinfos(file_path)
			assert(packets.to_i>0)
		rescue => e
			puts e.message.to_s
		ensure
			p "111111"
			p thr.alive?
			thr.kill if thr.alive?
			p "2222222"
			p tasklist_exists?("ping.exe")
			p taskkill("ping.exe")
		end

	end


	# Fake ftp_test
	# def test_fail
	#
	#   fail('Not implemented')
	# end
end