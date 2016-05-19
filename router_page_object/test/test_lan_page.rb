#encoding: utf-8
gem 'minitest'
require 'minitest/autorun'
require 'minitest/reporters'
file_path =File.expand_path('../../lib/router_page_object', __FILE__)
require file_path
# require 'router_page_object'

class Test<MiniTest::Unit::TestCase

		def testlan
				url               = "192.168.100.1"
				@tc_lan_ip_new    = "192.168.60.1"
				@tc_lan_start_new = "70"
				@tc_lan_end_new   = "80"
				@tc_lan_time      = 90
				usrname           = "admin"
				passwd            = "admin"
				@browser          = Watir::Browser.new :firefox, :profile => "default"
				@browser.cookies.clear
				@browser.goto url
				tag_usr      = 'admuser'
				tag_pw       = 'admpass'
				tag_login_btn= '登录'
				usrname      = "admin"
				passwd       = "admin"
				@browser.text_field(:name, tag_usr).set(usrname)
				@browser.text_field(:name, tag_pw).set(passwd)
				@browser.button(:value, tag_login_btn).click
				sleep 1
				lan_page = RouterPageObject::LanPage.new(@browser)
				#登录
				# lan_page.login_with(usrname, passwd, url)
				lan_page.open_lan_page(@browser.url)
				# lan_page.lan_ip = @tc_lan_ip_new
				# lan_page.lan_startip_set @tc_lan_start_new
				# lan_page.lan_endip_set @tc_lan_end_new
				# lan_page.btn_save_lanset
				# sleep @tc_lan_time
				@browser.close
		end


		def test_aui_close
				url      = "192.168.100.1"
				usrname  = "admin"
				passwd   = "admin"
				@browser = Watir::Browser.new :firefox, :profile => "default"
				@browser.cookies.clear
				lan_page = RouterPageObject::LanPage.new(@browser)
				#登录
				lan_page.login_with(usrname, passwd, url)
				lan_page.open_lan_page(@browser.url)
				# p lan_page.auti_titlebar?
				# p lan_page.auti_titlebar_element.div_element
				# p lan_page.auti_titlebar_element.div_element.exists?
				# p lan_page.auti_titlebar_element.link_element.exists?
				# p lan_page.auti_titlebar_element.link_element.text.encode("GBK")
				# p lan_page.auti_titlebar_element.link_element.click
				p lan_page.close_lan?
				# @browser.close
		end
end