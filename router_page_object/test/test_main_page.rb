#encoding: utf-8
gem 'minitest'
require 'minitest/autorun'
require 'minitest/reporters'
file_path =File.expand_path('../../lib/router_page_object', __FILE__)
require file_path
# require 'router_page_object'

class Test<MiniTest::Unit::TestCase
		def testreboot
				url      = "192.168.100.1"
				usrname  = "admin"
				passwd   = "admin"
				@browser = Watir::Browser.new :firefox, :profile => "default"
				operate  = RouterPageObject::LanPage.new(@browser)
				#登录
				operate.login_with(usrname, passwd, url)
				#设置dhcp
				operate.reboot
		end

		def test_lan_click
				@@ts_tag_lan_src = "lanset.asp"
				url              = "192.168.100.1"
				usrname          = "admin"
				passwd           = "admin"
				@browser         = Watir::Browser.new :firefox, :profile => "default"
				operate          = RouterPageObject::LanPage.new(@browser)
				#登录
				operate.login_with(usrname, passwd, url)
				operate.lan_span_obj.click
				@browser.iframe(src: @@ts_tag_lan_src).exists?
				# p operate.in_iframe(src: @@ts_tag_lan_src).exists?
		end
end
