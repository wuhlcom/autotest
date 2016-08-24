#encoding: utf-8
gem 'minitest'
require 'minitest/autorun'
require 'minitest/reporters'
file_path =File.expand_path('../../lib/router_page_object', __FILE__)
require file_path
# require 'router_page_object'

class Test<MiniTest::Unit::TestCase

		def test_detail
				url      = "192.168.100.1"
				usrname  = "admin"
				passwd   = "admin"
				t        = 10
				@browser = Watir::Browser.new :firefox, :profile => "default"
				detail   = RouterPageObject::WIFIDetail.new(@browser)
				#登录
				detail.login_with(usrname, passwd, url)
				detail.open_wifidetail_page(@browser.url)
				p detail.detail_title
				p detail.table_obj
				p detail.table_rows_obj
				p detail.ssid1_name
		end

end