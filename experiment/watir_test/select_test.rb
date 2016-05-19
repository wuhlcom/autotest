#encoding:utf-8
# require 'htmltags'
gem 'minitest'
require 'minitest/autorun'
require 'watir-webdriver'

class MyTestIpconfig < MiniTest::Unit::TestCase
	# include HtmlTag::WinCmd
	# include HtmlTag::Reporter
	# require 'pp'
	# stdio("ipconfig_test.log")
	i_suck_and_my_tests_are_order_dependent! #alpha，按顺序执行
	# Called before every ftp_test method runs. Can be used
	# to set up fixture information.
	def setup
		# Do nothing
	end

	def test_select
		@tc_tag_lan = "set_wifi"
		@tc_tag_select_list   = "security_mode"
		@browser    = Watir::Browser.new :ff, :profile => "default"
		@browser.goto("192.168.111.1")
		@browser.text_field(:name, 'admuser').set('admin')
		@browser.text_field(:name, 'admpass').set('admin')
		@browser.button(:value, '登录').click
		sleep 5
		@browser.span(:id => @tc_tag_lan).click
		sleep 2
		@lan_iframe = @browser.iframe
		 @select = @lan_iframe.select_list(id: @tc_tag_select_list)
		require 'pp'
		# pp @select.methods.sort
		p @select.select_value(/WPAPSKWPA2PSK/)
		p @select.select('WPA-PSK/WPA2-PSK')
		p @select.value
		p "================================================"
		p @select.select_value("NONE")
		p @select.select("无加密")
		p @select.value

		# p @select.selected_options
		# p @select.options
		p @select.selected?('WPA-PSK/WPA2-PSK')
		p @select.selected?('无加密')
		@browser.close
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