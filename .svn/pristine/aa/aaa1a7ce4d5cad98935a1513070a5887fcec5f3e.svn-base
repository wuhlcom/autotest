#encoding:utf-8
require 'htmltags'
# gem 'minitest'
# require 'minitest/autorun'
# require 'watir-webdriver'

class MyTestArtDialog < MiniTest::Unit::TestCase
	i_suck_and_my_tests_are_order_dependent! #alpha，按顺序执行

	include HtmlTag::WinCmd
	include HtmlTag::Reporter
	include HtmlTag::LogInOut

	def setup
		# Do nothing
	end

	def test_artdialog
		@tc_class           ="aui_state_focus aui_state_lock"
		@tc_aui_close       = "aui_close"
		@tc_tag_lan         = "set_wifi"
		@tc_tag_select_list = "security_mode"
		@browser            = Watir::Browser.new :ff, :profile => "default"
		@browser.goto("192.168.111.1")
		# login_no_default_ip(@browser)
		@browser.text_field(:name, 'admuser').set('admin')
		# @browser.text_field(name:'admuser',dxx:"1").set('admin')
		@browser.text_field(:name, 'admpass').set('admin')
		@browser.button(:value, '登录').click

		# @browser.close

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