#encoding: utf-8
gem 'minitest'
require 'minitest/autorun'
require 'minitest/reporters'
file_path =File.expand_path('../../lib/router_page_object', __FILE__)
require file_path
# require 'router_page_object'

class Test<MiniTest::Unit::TestCase
		def test_login
				url      = "192.168.100.1"
				usrname  = "admin"
				passwd   = "admin"
				@browser = Watir::Browser.new :firefox, :profile => "default"
				# @browser.cookies.clear
				login_router = RouterPageObject::LoginPage.new(@browser)
				#登录
				login_router.login_with(usrname, passwd, url)
				login_router.clear_cookies
				login_router.refresh
		end

end