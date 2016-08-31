#encoding: utf-8
gem 'minitest'
require 'minitest/autorun'
require 'minitest/reporters'
file_path =File.expand_path('../../lib/router_page_object', __FILE__)
require file_path
# require 'router_page_object'

class Test<MiniTest::Unit::TestCase
		def test_set_dhcp
				url      = "192.168.100.1"
				usrname  = "admin"
				passwd   = "admin"
				@browser = Watir::Browser.new :firefox, :profile => "default"
				@wan_page  = RouterPageObject::WanPage.new(@browser)
				@sys_page = RouterPageObject::SystatusPage.new(@browser)
				#登录
				@wan_page.login_with(usrname, passwd, url)
				#设置dhcp
				# operate.set_dhcp(@browser, @browser.url)
				# operate.open_wan_page(@browser.url)
				@wan_page.select_pppoe(@browser.url)
				@wan_page.pppoe_input("pppoe@163.gd", "PPPOETEST") #输入账号密码
				@wan_page.save
				sleep 60
				@sys_page.open_systatus_page(@browser.url)
				p @sys_page.get_wan_ip
		end
		#
		# def test_wireless_wan
		# 		url       = "192.168.100.1"
		# 		usrname   = "admin"
		# 		passwd    = "admin"
		# 		ssid      = "wifitest_autotest2"
		# 		pw        = "zhilutest"
		# 		@browser  = Watir::Browser.new :firefox, :profile => "default"
		# 		@wan_page = RouterPageObject::WanPage.new(@browser)
		# 		#登录
		# 		@wan_page.login_with(usrname, passwd, url)
		# 		@wan_page.set_bridge_pattern(ssid, pw, @browser.url)
		# end
end
