#encoding:utf-8
gem 'minitest'
require 'minitest/autorun'

file_path =File.expand_path('../../lib/htmltags', __FILE__)
require file_path
# require 'htmltags'
require 'drb/drb'
class MyTestString < MiniTest::Unit::TestCase
	include HtmlTag::Socket
	SERVER_URI="druby://50.50.50.57:8787"
	# Called before every ftp_test method runs. Can be used
	# to set up fixture information.
	def setup
		# Do nothing
	end

	def testtcp_conn
		ip   = "10.10.10.57"
		port = 11001
		DRb.start_service
		@wifi   = DRbObject.new_with_uri(SERVER_URI)
		srv_thr = @wifi.tcp_multi_server(ip, port)
		rs      = tcp_client(ip, port)
		p rs.tcp_message
		p rs.tcp_state
		# sleep 10
		p srv_thr.alive?
		srv_thr.kill if srv_thr.alive?
	end

	def testtcp_client
		ip   = "10.10.10.57"
		port = 16801
		# DRb.start_service
		# @wifi = DRbObject.new_with_uri(SERVER_URI)
		# p srv_thr = @wifi.tcp_simple_server(ip, port)
		rs   = tcp_client(ip, port)
		p rs.tcp_message
		p rs.tcp_state
		# p srv_thr.alive?
		# srv_thr.kill if srv_thr.alive?
	end

	def testudp_conn
		sip   = "10.10.10.57"
		sport = 10001
		cip   = "192.168.100.101"
		cport = 10002
		DRb.start_service
		@wifi   = DRbObject.new_with_uri(SERVER_URI)
		srv_thr = @wifi.udp_server(sip, sport)
		# sleep 5
		rs      = udp_client(cip, cport, sip, sport, "UDP ftp_test")
		p rs.udp_message
		p rs.udp_state
		srv_thr.kill if srv_thr.alive?
	end

	def testudp_client
		sip   = "10.10.10.57"
		cip   = "192.168.100.101"
		sport = 15801
		cport = 12323
		rs    = udp_client(cip, cport, sip, sport, "UDP ftp_test")
		p rs.udp_message
		p rs.udp_state
	end

	def testhttp_conn
		ip   = "10.10.10.57"
		port = 80
		content = "Hello"
		DRb.start_service
		@wifi   = DRbObject.new_with_uri(SERVER_URI)
		srv_thr = @wifi.http_server(ip, port, content)
		# srv_thr = @wifi.http_server(ip, port)
		rs = http_client(ip, "/", "80")
		p rs
		srv_thr.kill if srv_thr.alive?
	end
	def testhttp_client
		ip   = "10.10.10.57"
		port = 80
		# content = "Hello"
		# DRb.start_service
		# @wifi   = DRbObject.new_with_uri(SERVER_URI)
		# srv_thr = @wifi.http_server(ip, port, content)
		# srv_thr = @wifi.http_server(ip, port)
		rs = http_client(ip, "/", "80")
		p rs
		# srv_thr.kill if srv_thr.alive?
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