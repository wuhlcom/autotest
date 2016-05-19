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

	def test_confirmdialog
		# @tc_upload_file_current = Dir.glob(@ts_upload_directory+"/*").find { |file| file=~/.*_current/i }
		# puts "Current version file:#{@tc_upload_file_current}"
		#
		# @tc_upload_file_new = Dir.glob(@ts_upload_directory+"/*").find { |file| file=~/.*_new/i }
		# puts "New version file:#{@tc_upload_file_new}"
		#
		# @tc_upload_file_old = Dir.glob(@ts_upload_directory+"/*").find { |file| file=~/.*_old/i }
		# puts "Old version file:#{@tc_upload_file_old}"
		#
		# #"\u7CFB\u7EDF\u7248\u672C\uFF1AV100R003SPC010 MAC\uFF1A00:0C:43:76:20:66"
		# version_info = @browser.b(id: @ts_tag_systemver).parent.text
		#
		# version_info =~/(V\qos+R\qos+SPC\qos+)\s+MAC/
		# @tc_vername_current = Regexp.last_match(1)
		# puts "Before uploading the version name is: #{@tc_vername_current}"

		@tc_wait_time       = 2
		@tc_gap_time        = 3
		@tc_net_wait_time   = 60
		@tc_wait_for_reboot = 120
		@tc_wait_for_login  = 80

		@tc_tag_systemset    = "syssetting"
		@tc_tag_class        = "selected"
		@tc_tag_button       = "button"
		@tc_tag_update_state = "active"
		@tc_tag_update_src   = "update.asp"
		@tc_tag_update       = "update-titile"

		@tc_tag_verion          = "version"
		@tc_tag_update_filename = "filename"

		@tc_tag_file_div   = "aui_state_lock aui_state_focus" #共享目录的根DIV，focus在后表示选中了当前div
		@tc_tag_update_btn = "update_submit_btn"

		@tc_tag_update_tip_div = "aui_state_noTitle aui_state_focus aui_state_lock"
		@tc_tag_update_tip     = "aui_content"
		@tc_tag_updating       = "固件升级进行中"
		@tc_tag_updated        = "固件升级完成"
		@tc_tag_confirm_btn    = "aui_state_highlight"

		@ts_default_ip = "192.168.111.1"
		@browser       = Watir::Browser.new :ff, :profile => "default"
		@ts_tag_options      = "options"
		@ts_tag_advance_src  = "advance.asp"

		@tc_upload_file_current = "E:/Automation/frame/uploads/MTK-V100R003SPC010_current"
		login_recover(@browser, @ts_default_ip)
		@browser.link(id: @ts_tag_options).wait_until_present(@tc_wait_time)
		@browser.link(id: @ts_tag_options).click
		@advance_iframe = @browser.iframe(src: @ts_tag_advance_src)
		assert(@advance_iframe.exists?, "打开高级设置失败!")

		#选择‘系统设置’
		sysset = @advance_iframe.link(id: @tc_tag_systemset).class_name
		unless sysset == @tc_tag_systemset
			@advance_iframe.link(id: @tc_tag_systemset).click
			sleep @tc_gap_time
		end

		#选择 "固件升级"
		update_label       = @advance_iframe.link(id: @tc_tag_update)
		update_label_state = update_label.parent.class_name
		update_label.click unless update_label_state==@tc_tag_update_state
		sleep @tc_gap_time

		#设置升级文件
		@advance_iframe.file_field(id: @tc_tag_update_filename).set(@tc_upload_file_current)
		@advance_iframe.button(id: @tc_tag_update_btn).click

		#由于高版本升低版本会弹出升级提示框
		p @tc_tag_confirm_btn
		update_confirm = @advance_iframe.button(class_name: @tc_tag_confirm_btn)
		update_confirm1 = @advance_iframe.button(text: '确认')
		sleep 3
		p update_confirm.exists?
		p update_confirm1.exists?


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