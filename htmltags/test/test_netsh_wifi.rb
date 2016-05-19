require 'test/unit'
file_path =File.expand_path('../../lib/htmltags', __FILE__)
require file_path
# require 'htmltags'
class MyTestWIfi < Test::Unit::TestCase
	include HtmlTag::WinCmd
	include HtmlTag::Reporter
	# Called before every ftp_test method runs. Can be used
	# to set up fixture information.
	def setup
		# Do nothing
	end

	# Called after every ftp_test method runs. Can be used to tear
	# down fixture information.
	require "pp"

	def testshow_interfaces
	# pp	show_interfaces
	end

	def test_show_networks
		pp show_networks
	end

	# def test_netsh_sn
	# 	p netsh_sn.encoding
	# end

	def teardown
		# Do nothing
	end

	# Fake ftp_test
	# def test_fail
	#
	#   fail('Not implemented')
	# end
end