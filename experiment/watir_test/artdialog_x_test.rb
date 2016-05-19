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

	#artDialog x
	def testartdialog
		@tc_class           ="aui_state_focus aui_state_lock"
		@tc_tag_lan_src     = "lanset.asp"
		@tc_aui_close       = "aui_close"
		@tc_tag_lan         = "set_wifi"
		@tc_tag_select_list = "security_mode"
		js                  ="var list = art.dialog.list;for (var i in list) {list[i].close();}"
		@browser            = Watir::Browser.new :ff, :profile => "default"
		@browser.goto("192.168.111.1")
		@browser.text_field(:name, 'admuser').set('admin')
		@browser.text_field(:name, 'admpass').set('admin')
		@browser.button(:value, '登录').click
		sleep 5
		@browser.span(:id => @tc_tag_lan).click
		sleep 2
		lan =@browser.div(class_name: @tc_class)
		#关闭前判断是否存在
		p lan.exists?
		lan_set =@browser.iframe(src: @tc_tag_lan_src)
		p lan_set.exists?
		@browser.execute_script(js)
		#关闭后判断是否存在
		p lan.exists?
		p lan_set.exists?
		# @lan_iframe = @browser.iframe
		# @select     = @lan_iframe.select_list(id: @tc_tag_select_list)
		# close_obj=@lan_iframe.link(class_name:@tc_aui_close)
		# p	close_obj.exists?
		# p	close_obj.href
		# @lan_iframe.link(class_name:@tc_aui_close).click
		# @lan_iframe.execute_script(close_obj.href)
		# @lan_iframe.execute_script("$(arguments[0]).hide();", close_obj) #隐藏div
		# @browser.execute_script("$(arguments[0]).hide();", lan)

		# @lan_iframe.execute_script("$(arguments[0]).close();", close_obj)
		# @browser.close
	end

	def testadvance
		@browser                 = Watir::Browser.new :ff, :profile => "default"
		@ts_default_ip           = "192.168.111.1"
		rs_login                 = login_recover(@browser, @ts_default_ip)
		@ts_tag_options          = "options"
		@ts_tag_advance_src      = "advance.asp"
		@tc_wait_time            = 2
		@tc_gap_time             = 3
		@tc_close_share          = 5
		@tc_wait_for_reboot      = 210
		@tc_tag_systemset        = "syssetting"
		@tc_tag_class            = "selected"
		@tc_tag_file_share       = "USB-titile"
		@tc_tag_button           = "button"
		@tc_tag_file_share_state = "active"
		@tc_share_switch_off     = "off"
		@tc_file_share_dir       = "Folder_structure.asp"
		@tc_storage_usb          = "U盘"
		@tc_storage_sd           = "SD卡"
		@tc_share_dir            = "文件测试"
		@tc_test_file            = "测试文件_TEST.txt"
		@tc_tag_close_share      = "关闭共享"
		@tc_tag_back             = "返回上一级"

		@browser.link(id: @ts_tag_options).wait_until_present(@tc_wait_time)
		@browser.link(id: @ts_tag_options).click
		@advance_iframe = @browser.iframe
		assert_match /#{@ts_tag_advance_src}/i, @advance_iframe.src, "打开高级设置失败!"

		#选择‘系统设置’
		sysset = @advance_iframe.link(id: @tc_tag_systemset).class_name
		unless sysset ==@tc_tag_systemset
			@advance_iframe.link(id: @tc_tag_systemset).click
			sleep @tc_gap_time
		end
		# #选择 "文件共享"
		# file_share_label       = @advance_iframe.link(id: @tc_tag_file_share)
		# file_share_label_state = file_share_label.parent.class_name
		# file_share_label.click unless file_share_label_state==@tc_tag_file_share_state
		# sleep @tc_gap_time

		# rs = @browser.iframe(src: @tc_file_share_dir).exists?
		# unless rs
		#打开"文件共享"开关
		# file_share_switch = @advance_iframe.button(type: @tc_tag_button)
		# switch_state      = file_share_switch.class
		# file_share_switch.click unless switch_state == @tc_share_switch_off
		#sleep 30
		p js = "var list = art.dialog.list;for (var i in list) {list[i].close();}"

		# @browser.execute_script("var list = art.dialog.list;for (var i in list) {list[i].close();}")
		# @advance_iframe.execute_script(js)
		@browser.execute_script(js)
	end


	def test_hide
		@browser       = Watir::Browser.new :ff, :profile => "default"
		@ts_default_ip = "192.168.111.1"
		rs_login       = login_recover(@browser, @ts_default_ip)

		@ts_tag_options          = "options"
		@ts_tag_advance_src      = "advance.asp"
		@tc_wait_time            = 2
		@tc_gap_time             = 3
		@tc_close_share          = 5
		@tc_wait_for_reboot      = 210
		@tc_tag_systemset        = "syssetting"
		@tc_tag_class            = "selected"
		@tc_tag_file_share       = "USB-titile"
		@tc_tag_button           = "button"
		@tc_tag_file_share_state = "active"
		@tc_share_switch_off     = "off"
		@tc_file_share_dir       = "Folder_structure.asp"
		@tc_storage_usb          = "U盘"
		@tc_storage_sd           = "SD卡"
		@tc_share_dir            = "文件测试"
		@tc_test_file            = "测试文件_TEST.txt"
		@tc_tag_close_share      = "关闭共享"
		@tc_tag_back             = "返回上一级"

		@browser.link(id: @ts_tag_options).wait_until_present(@tc_wait_time)
		@browser.link(id: @ts_tag_options).click
		@advance_iframe = @browser.iframe
		assert_match /#{@ts_tag_advance_src}/i, @advance_iframe.src, "打开高级设置失败!"

		#选择‘系统设置’
		sysset = @advance_iframe.link(id: @tc_tag_systemset).class_name
		unless sysset ==@tc_tag_systemset
			@advance_iframe.link(id: @tc_tag_systemset).click
			sleep @tc_gap_time
		end

		# #选择 "文件共享"
		# file_share_label       = @advance_iframe.link(id: @tc_tag_file_share)
		# file_share_label_state = file_share_label.parent.class_name
		# file_share_label.click unless file_share_label_state==@tc_tag_file_share_state
		# sleep @tc_gap_time

		# rs = @browser.iframe(src: @tc_file_share_dir).exists?
		# unless rs
		# 	#打开 "文件共享" 开关
		# 	file_share_switch = @advance_iframe.button(type: @tc_tag_button)
		# 	switch_state      = file_share_switch.class
		# 	file_share_switch.click unless switch_state == @tc_share_switch_off
		# 	sleep 10
		# end

		@tc_tag_advance_div = "aui_state_lock aui_state_focus" #高级设置的根DIV
		@tc_tag_file_div    = "aui_state_focus aui_state_lock" #共享目录的DIV


		##根据style来定位元素
		@style              ="z-index"
		p div = @browser.element(xpath: "//div[contains(@style,'1988')]")
		p div.exists?

		@tc_tag_zindex="1988"
		@advance_div  = @browser.div(class_name: @tc_tag_div)
		@browser.execute_script("$(arguments[0]).hide();", div)
		# /html/body/div[8]
		# p @shade_div = @browser.element(xpath: "/html/body/div[8]")
		# p @shade_div.style("z-index")
		# @browser.execute_script("$(arguments[0]).hide();", @advance_div)
		# @browser.execute_script("$(arguments[0]).hide();", @tc_tag_file_div)

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