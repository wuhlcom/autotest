#encoding: utf-8
gem 'minitest'
require 'minitest/autorun'
require 'minitest/reporters'
file_path =File.expand_path('../../lib/router_page_object', __FILE__)
require file_path
# require 'router_page_object'

class Test<MiniTest::Unit::TestCase

		def test_advance_recover
				url           = "192.168.50.1"
				usrname       = "admin"
				passwd        = "admin"
				@browser      = Watir::Browser.new :firefox, :profile => "default"
				acc_page = RouterPageObject::AccompanyRouter.new(@browser)
				#登录
				# acc_page.login_with(usrname, passwd, url)
				acc_page.login_accompany_router(url)
				# acc_page.open_wireless_24g_page
				acc_page.wireless_24g_options(@browser)

				# p acc_page.get_version_info

		end

end