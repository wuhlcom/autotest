#encoding: utf-8
gem 'minitest'
require 'minitest/autorun'
require 'minitest/reporters'
file_path =File.expand_path('../../lib/router_page_object', __FILE__)
require file_path
# require 'router_page_object'

class Test<MiniTest::Unit::TestCase

		def testsystatus
				url           = "192.168.100.1"
				usrname       = "admin"
				passwd        = "admin"
				@browser      = Watir::Browser.new :firefox, :profile => "default"
				systatus_page = RouterPageObject::SystatusPage.new(@browser)
				#登录
				systatus_page.login_with(usrname, passwd, url)
				systatus_page.open_systatus_page(@browser.url)
		end

		def testruntime
				url           = "192.168.100.1"
				usrname       = "admin"
				passwd        = "admin"
				t             = 10
				@browser      = Watir::Browser.new :firefox, :profile => "default"
				systatus_page = RouterPageObject::SystatusPage.new(@browser)
				#登录
				systatus_page.login_with(usrname, passwd, url)
				systatus_page.open_systatus_page(@browser.url)
				p systatus_page.get_runtime
				p t1 = Time.now
				sleep t
				@browser.refresh
				systatus_page.open_systatus_page(@browser.url)
				p systatus_page.get_runtime
				p t2 = Time.now
				p t2-t1
		end

		def testwifisw
				url           = "192.168.100.1"
				usrname       = "admin"
				passwd        = "admin"
				t             = 15
				@browser      = Watir::Browser.new :firefox, :profile => "default"
				systatus_page = RouterPageObject::SystatusPage.new(@browser)
				#登录
				systatus_page.login_with(usrname, passwd, url)
				systatus_page.open_systatus_page(@browser.url)
				sleep t
				p systatus_page.get_wifi_ssid
				p systatus_page.get_wifi_switch
				p systatus_page.get_wifi_switch_5g
		end

		def testchannel
				url           = "192.168.100.1"
				usrname       = "admin"
				passwd        = "admin"
				t             = 15
				@browser      = Watir::Browser.new :firefox, :profile => "default"
				systatus_page = RouterPageObject::SystatusPage.new(@browser)
				#登录
				systatus_page.login_with(usrname, passwd, url)
				systatus_page.open_systatus_page(@browser.url)
				sleep t
				p systatus_page.get_wifi_channel
				p systatus_page.get_wifi_channel_5g
				# p str = "CHANNEL 2G\n 11"
				# # /[\p{Han}+|CHANNEL\s+.+G]\s+(?<channel>.*)/ium=~str
				# /CHANNEL\s+.+G\s+(?<channel>.*)/ium=~str
				# p channel
				# # p "\n"=~/\s/
		end

		def testlaninfo
				url            = "192.168.100.1"
				usrname        = "admin"
				passwd         = "admin"
				t              = 10
				@browser       = Watir::Browser.new :firefox, :profile => "default"
				@systatus_page = RouterPageObject::SystatusPage.new(@browser)
				#登录
				@systatus_page.login_with(usrname, passwd, url)
				@systatus_page.open_systatus_page(@browser.url)
				sleep t
				puts "#{@systatus_page.version_info}".encode("GBK")
				p verinfo = @systatus_page.version_info_element.visible?
				# assert(verinfo, "未显示版本信息")

				puts "#{@systatus_page.wan_info}".encode("GBK")
				p wanifo = @systatus_page.wan_info_element.visible?
				# refute(wanifo, "不应该显示WAN信息")

				p laninfo = @systatus_page.lan_info_element.visible?
				puts "#{@systatus_page.lan_info}".encode("GBK")
				# assert(laninfo, "未显示LAN信息")

				p wifi_info = @systatus_page.wifi_info_element.visible?
				puts "#{@systatus_page.wifi_info}".encode("GBK")
				# assert(wifi_info, "未显示WIFI信息")
		end

		def test_3g_info
				url            = "192.168.100.1"
				usrname        = "admin"
				passwd         = "admin"
				t              = 10
				@browser       = Watir::Browser.new :firefox, :profile => "default"
				@systatus_page = RouterPageObject::SystatusPage.new(@browser)
				#登录
				@systatus_page.login_with(usrname, passwd, url)
				@systatus_page.open_systatus_page(@browser.url)

				# p net_type= @systatus_page.net_type
				# net_type=~/([34]G)/
				# p $1
				# p Regexp.last_match(1)
				# p sysversion = @systatus_page.get_current_software_ver
				@systatus_page.more_obj
		end

end
