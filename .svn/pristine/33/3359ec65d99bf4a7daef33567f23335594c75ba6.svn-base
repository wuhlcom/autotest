#encoding: utf-8
gem 'minitest'
require 'minitest/autorun'
require 'minitest/reporters'
file_path =File.expand_path('../../lib/router_page_object', __FILE__)
require file_path
# require 'router_page_object'

class Test<MiniTest::Unit::TestCase

		def test_reboot
				url      = "192.168.100.1"
				usrname  = "admin"
				passwd   = "admin"
				@browser = Watir::Browser.new :firefox, :profile => "default"
				options  = RouterPageObject::OptionsPage.new(@browser)
				#登录
				options.login_with(usrname, passwd, url)
				options.restart_step(@browser.url, strategy="一次", time=2)
		end
end