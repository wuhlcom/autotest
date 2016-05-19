#encoding:utf-8
require 'htmltags'
#gem 'minitest'
#require 'minitest/autorun'
#require 'watir-webdriver'

class Selenium::WebDriver::Firefox::Profile
	attr_accessor :model

	def model_windows_format
		@model = model.gsub(/\/|\\/, "\\\\")
	end

	def model_linux_format
		@model = model.gsub(/\\\\|\\/, "\/")
	end
end

class MyTestArtDownload < MiniTest::Unit::TestCase
	i_suck_and_my_tests_are_order_dependent! #alpha，按顺序执行

	include HtmlTag::WinCmd
	include HtmlTag::Reporter
	include HtmlTag::LogInOut

	def setup
		# Do nothing
	end

	def test_upload
		@ts_tag_options     = "options"
		@ts_tag_advance_src = "advance.asp"

		@tc_wait_time            = 2
		@tc_gap_time             = 3
		@tc_close_share          = 5
		@tc_wait_for_reboot      = 30
		@tc_wait_system          = 180
		@tc_tag_systemset        = "syssetting"
		@tc_tag_class            = "selected"
		@tc_tag_file_share       = "USB-titile"
		@tc_tag_reset            = "reset-titile"
		@tc_tag_button           = "button"
		@tc_tag_file_share_state = "active"
		@tc_share_switch_off     = "off"
		@tc_share_switch_on      = "on"
		@tc_file_share_dir       = "Folder_structure.asp"
		@tc_storage_usb          = "U盘"
		@tc_storage_sd           = "SD卡"
		@tc_share_dir            = "文件测试"
		@tc_test_file            = "测试文件_TEST.txt"
		@tc_download_file        = "TortoiseSVN_1.8.4_TEST.rar"
		@tc_tag_close_share      = "关闭共享"
		@tc_tag_back             = "返回上一级"
		@tc_tag_file_div         = "aui_state_lock aui_state_focus" #共享目录的根DIV，focus在后表示选中了当前div
		@tc_tag_style_zindex     = "z-index"

		@tc_tag_file_name = "filename"
		@tc_tag_reset            = "reset-titile"

		@browser = Watir::Browser.new :firefox, :profile => "default"
		p download_directory = "#{Dir.pwd}/downloads"
		download_directory.gsub!("/", "\\\\") if Selenium::WebDriver::Platform.windows?
		#读取默认配置文件对象
		default_profile = Selenium::WebDriver::Firefox::Profile.from_name("default")
		default_profile.model_linux_format

		default_profile['browser.download.folderList']               = 2 # custom location
		default_profile['browser.download.dir']                      = download_directory
		default_profile['browser.helperApps.alwaysAsk.force']        = false
		# default_profile['browser.helperApps.neverAsk.openFile']     = "text/txt,application/rar,application/zip,application/octet-stream"
		default_profile['browser.helperApps.neverAsk.saveToDisk']    = "text/txt,application/rar,application/zip,application/octet-stream"
		# default_profile['dom.disable_open_during_load']             = true
		default_profile['browser.download.manager.showWhenStarting'] = false
		default_profile['browser.download.progressDnldDialog']       = false
		# default_profile.add_extension "../path/to/firebug.xpi"
		@browser                                                     = Watir::Browser.new :firefox, :profile => default_profile
		@ts_default_ip                                               = "192.168.111.1"
		rs_login                                                     = login_recover(@browser, @ts_default_ip)

		@browser.link(id: @ts_tag_options).wait_until_present(@tc_wait_time)
		@browser.link(id: @ts_tag_options).click
		@advance_iframe = @browser.iframe

		#选择‘系统设置’
		sysset          = @advance_iframe.link(id: @tc_tag_systemset).class_name
		unless sysset == @tc_tag_systemset
			@advance_iframe.link(id: @tc_tag_systemset).click
			sleep @tc_gap_time
		end

		#选择 "恢复出厂设置"
		recover_share_label       = @advance_iframe.link(id: @tc_tag_reset)
		recover_share_label_state = recover_share_label.parent.class_name
		recover_share_label.click unless recover_share_label_state==@tc_tag_file_share_state
		sleep @tc_gap_time
		file_path = "E:\\software\\V100R003SPC004"
		@advance_iframe.file_field(id:@tc_tag_file_name).set(file_path)
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