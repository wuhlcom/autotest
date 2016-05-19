#encoding: utf-8
gem 'minitest'
require 'minitest/autorun'
require 'minitest/reporters'
file_path =File.expand_path('../../lib/router_page_object', __FILE__)
require file_path
# require 'router_page_object'

class Test<MiniTest::Unit::TestCase
		def test_set_pw1
				url      = "192.168.100.1"
				usrname  = "admin"
				passwd   = "admin"
				@browser = Watir::Browser.new :firefox, :profile => "default"
				@browser.cookies.clear
				@wifi_page = RouterPageObject::WIFIPage.new(@browser)
				#登录
				@wifi_page.login_with(usrname, passwd, url)
				@wifi_page.open_wifi_page(@browser.url)
				@wifi_page.close_wifi_page
				# @wifi_page.select_wifi_basic
				# # @wifi_page.select_2g_set
		end
end
