#encoding: utf-8
gem 'minitest'
require 'minitest/autorun'
require 'minitest/reporters'
file_path =File.expand_path('../../lib/router_page_object', __FILE__)
require file_path
# require 'router_page_object'

class Test<MiniTest::Unit::TestCase

		def test_advance_recover
				url           = "192.168.100.1"
				usrname       = "admin"
				passwd        = "admin"
				@browser      = Watir::Browser.new :firefox, :profile => "default"
				systatus_page = RouterPageObject::AdvancePage.new(@browser)
				#登录
				systatus_page.login_with(usrname, passwd, url)
				systatus_page.recover_factory(@browser.url)
		end

end