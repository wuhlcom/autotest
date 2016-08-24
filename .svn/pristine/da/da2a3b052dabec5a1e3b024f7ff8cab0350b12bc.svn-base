#encoding: utf-8
gem 'minitest'
require 'minitest/autorun'
require 'minitest/reporters'
file_path =File.expand_path('../../lib/router_page_object', __FILE__)
require file_path
# require 'router_page_object'

class Test<MiniTest::Unit::TestCase

		def test_diag
				ip       = "192.168.100.1"
				usrname  = "admin"
				userpw   = "admin"
				@browser = Watir::Browser.new :ff, :profile => "default"
				@browser.goto(ip)
				@browser.text_field(:name, 'admuser').set(usrname)
				@browser.text_field(:name, 'admpass').set(userpw)
				@browser.button(:value, '登录').click
				tag_lan="set_wifi"
				@browser.span(:id => tag_lan).wait_until_present(5)
				@diagnose_page = RouterPageObject::DiagnosePage.new(@browser)
				@diagnose_page.initialize_diag(@browser)
				p @diagnose_page.detect_rs.encode("GBK")
				@diagnose_page.rediagnose
				p @diagnose_page.detect_rs.encode("GBK")
		end
end
