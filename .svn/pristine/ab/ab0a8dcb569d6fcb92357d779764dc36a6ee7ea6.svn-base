#encoding: utf-8
gem 'minitest'
require 'minitest/autorun'
require 'minitest/reporters'
file_path =File.expand_path('../../lib/router_page_object', __FILE__)
require file_path
# require 'router_page_object'

class Test<MiniTest::Unit::TestCase
		def testapmode
				url      = "192.168.100.1"
				usrname  = "admin"
				passwd   = "admin"
				@browser = Watir::Browser.new :firefox, :profile => "default"
				operate  = RouterPageObject::ModePage.new(@browser)
				#登录
				operate.login_with(usrname, passwd, url)
				operate.open_mode_page(@browser.url)
				#设置dhcp
				# p operate.apmode?
		end

		def testapmode_option_page
				url           = "192.16.100.1"
				usrname       = "admin"
				passwd        = "admin"
				@browser      = Watir::Browser.new :firefox, :profile => "default"
				# @options_page  = RouterPageObject::ModePage.new(@browser)
				# @mode_page.save_apmode(@browser.url)
				@options_page = RouterPageObject::APOptionsPage.new(@browser)
				@options_page.login_with(usrname, passwd, url)
				#ap模式高级设置里只有系统设置的功能，查看打开高级设置后还有哪些功能
				@options_page.open_options_page(@browser.url)
				sleep 5
				p @options_page.apply_settings?
				p @options_page.apply_settings_element.visible?
				p @options_page.sysset?
				p @options_page.sysset_element.visible?
				refute(@options_page.apply_settings_element.visible?, "切换到AP模式后应用设置功能不应该存在")
				refute(@options_page.network_element.visible?, "切换到AP模式后网络设置功能不应该存在")
				refute(@options_page.security_settings_element.visible?, "切换到AP模式后安全设置功能不应该存在")
				refute(@options_page.traffic_manage_element.visible?, "切换到AP模式后流量管理功能不应该存在")
				assert(@options_page.sysset_element.visible?, "切换到AP模式后系统设置功能应该存在")
		end

		def test_rtmode_lan
				@@ts_tag_lan_src = "lanset.asp"
				url              = "192.168.100.1"
				usrname          = "admin"
				passwd           = "admin"
				@browser         = Watir::Browser.new :firefox, :profile => "default"
				@mode_page       = RouterPageObject::ModePage.new(@browser)
				# @mode_page.save_apmode(@browser.url)
				# @options_page = RouterPageObject::APOptionsPage.new(@browser)
				@mode_page.login_with(usrname, passwd, url)
				#ap模式高级设置里只有系统设置的功能，查看打开高级设置后还有哪些功能
				@mode_page.lan_span_obj.click
				sleep 2
				p @browser.iframe(src: @@ts_tag_lan_src).exists?
		end
end
