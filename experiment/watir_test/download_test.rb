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

	def test_download
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
		@tc_tag_button           = "button"
		@tc_tag_file_share_state = "active"
		@tc_share_switch_off     = "off"
		@tc_share_switch_on      = "on"
		@tc_file_share_dir       = "Folder_structure.asp"
		@tc_storage_usb          = "U盘"
		@tc_storage_sd           = "SD卡"
		@tc_share_dir            = "文件测试"
		@tc_test_file            = "测试文件_TEST.txt"
		@tc_download_file        = "pycharm_TEST.zip"
		@tc_download_file        = "pycharm_TEST.exe"
		@tc_tag_close_share      = "关闭共享"
		@tc_tag_back             = "返回上一级"
		@tc_tag_file_div         = "aui_state_lock aui_state_focus" #共享目录的根DIV，focus在后表示选中了当前div
		@tc_tag_style_zindex     = "z-index"

=begin
    #新建配置文件，设置下载
		download_directory = "#{Dir.pwd}/downloads"
		download_directory.gsub!("/", "\\") if Selenium::WebDriver::Platform.windows?
		profile                                             = Selenium::WebDriver::Firefox::Profile.new()
		profile['browser.download.folderList']              = 2 # custom location
		profile['browser.download.dir']                     = download_directory
		profile['browser.helperApps.alwaysAsk.force;false'] = false
		# profile['browser.helperApps.neverAsk.openFile']     = "text/txt,application/rar,application/zip,application/octet-stream"
		profile['browser.helperApps.neverAsk.saveToDisk']   = "text/txt,application/rar,application/zip,application/octet-stream"
		# profile['dom.disable_open_during_load']             = true
		profile['browser.download.manager.showWhenStarting'] = false
		profile.add_extension "../path/to/firebug.xpi"
=end

		#@browser = Watir::Browser.new :firefox, :profile => "default"
		p download_directory = "#{Dir.pwd}/downloads"
		download_directory.gsub!("/", "\\\\") if Selenium::WebDriver::Platform.windows?
		# p Selenium::WebDriver.root
		#读取默认配置文件对象
		default_profile = Selenium::WebDriver::Firefox::Profile.from_name("default")
		p default_profile
		default_profile.model_linux_format
		p default_profile
		# p default_profile.native_events = true
		p default_profile.class
		# p @browser.fetch_profile

		default_profile['browser.download.folderList']               = 2 # custom location
		default_profile['browser.download.dir']                      = download_directory
		#default_profile['browser.helperApps.alwaysAsk.force']        = false
		#default_profile['browser.helperApps.neverAsk.openFile']      = false#"text/txt,application/doc,application/xslx"
		default_profile['browser.helperApps.neverAsk.saveToDisk']    = "text/txt,application/octet-stream"
		#default_profile['dom.disable_open_during_load']              = true
		#default_profile['browser.download.manager.showWhenStarting'] = false
		#default_profile['browser.download.progressDnldDialog']       = false
		#default_profile.add_extension "../path/to/firebug.xpi"
		@browser                                                     = Watir::Browser.new :firefox, :profile => default_profile
		@browser.cookies.clear
		@ts_default_ip                                               = "192.168.111.1"
		rs_login                                                     = login_recover(@browser, @ts_default_ip)

		# default_profile.update_user_prefs_in(default_profile.model)

		@browser.link(id: @ts_tag_options).wait_until_present(@tc_wait_time)
		@browser.link(id: @ts_tag_options).click
		@advance_iframe = @browser.iframe

		#选择‘系统设置’
		sysset          = @advance_iframe.link(id: @tc_tag_systemset).class_name
		unless sysset == @tc_tag_systemset
			@advance_iframe.link(id: @tc_tag_systemset).click
			sleep @tc_gap_time
		end

		#选择 "文件共享"
		file_share_label       = @advance_iframe.link(id: @tc_tag_file_share)
		file_share_label_state = file_share_label.parent.class_name
		file_share_label.click unless file_share_label_state==@tc_tag_file_share_state
		sleep @tc_gap_time
		file_share              = @browser.iframe(src: @tc_file_share_dir)
		rs                      = file_share.exists?
		#如果rs为true,说明文件共享已被打开，这不符合默认设置
		# assert_equal(false, rs, "文件共享已经开启")

		#打开"文件共享"开关
		# file_share_switch = @advance_iframe.button(type: @tc_tag_button)
		# switch_state      = file_share_switch.class_name
		# if switch_state == @tc_share_switch_off
		# 	file_share_switch.click
		# end

		rs                      = @browser.iframe(src: @tc_file_share_dir).wait_until_present(@tc_gap_time)
		# assert(rs, "未打开文件共享目录界面")
		@file_share_iframe      = @browser.iframe(src: @tc_file_share_dir)
		usb_dir                 = @file_share_iframe.link(text: @tc_storage_usb)
		@back_to_previous_level = @file_share_iframe.link(text: @tc_tag_back)
		puts "查看#{@tc_storage_usb}中的文件".to_gbk
		assert(usb_dir.exists?, "未显示U盘")
		usb_dir.click

		#查看U盘中的文件夹
		sub_dir    =@file_share_iframe.link(text: @tc_share_dir)
		rs_sub_dir = sub_dir.wait_until_present(@tc_gap_time)
		assert(rs_sub_dir, "找不到U盘中的文件夹")
		dir_name = sub_dir.parent.parent[0].text
		dir_size = sub_dir.parent.parent[1].text
		puts "文件夹名：#{dir_name}----文件大小:#{dir_size}".to_gbk
		sub_dir.click

		#查看U盘中的文件
		file    = @file_share_iframe.link(text: @tc_test_file)
		rs_file = file.wait_until_present(@tc_gap_time)
		assert(rs_file, "未找到测试文件")
		file_name = file.parent.parent[0].text
		file_size = file.parent.parent[1].text
		puts "测试文件名：#{file_name}------------文件大小：#{file_size}".to_gbk

		download_file = @file_share_iframe.link(text: @tc_download_file)
		download_file.click

		# #返回到根目录
		# @back_to_previous_level.click
		# rs_back_sub_dir = sub_dir.wait_until_present(@tc_gap_time)
		# assert(rs_back_sub_dir, "返回到上一级目录失败")
		# @back_to_previous_level.click
		# rs_back_usb_dir = usb_dir.wait_until_present(@tc_gap_time)
		# assert(rs_back_usb_dir, "返回到U盘根目录失败")


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