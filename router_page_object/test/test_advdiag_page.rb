#encoding: utf-8
gem 'minitest'
require 'minitest/autorun'
require 'minitest/reporters'
file_path =File.expand_path('../../lib/router_page_object', __FILE__)
require file_path
# require 'router_page_object'

class Test<MiniTest::Unit::TestCase

		def testdiag
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
				@diagnose_page = RouterPageObject::DiagnoseAdvPage.new(@browser)
				@diagnose_page.initialize_diagadv(@browser)
		end

		def test_diag_check
				ip       = "192.168.100.1"
				usrname  = "admin"
				userpw   = "admin"
				tc_web   = "http://www.baidu.com"
				@browser = Watir::Browser.new :ff, :profile => "default"
				@browser.goto(ip)
				@browser.text_field(:name, 'admuser').set(usrname)
				@browser.text_field(:name, 'admpass').set(userpw)
				@browser.button(:value, '登录').click
				tag_lan="set_wifi"
				@browser.span(:id => tag_lan).wait_until_present(5)
				@diagnose_page = RouterPageObject::DiagnoseAdvPage.new(@browser)
				@diagnose_page.initialize_diagadv(@browser)
				@diagnose_page.url_addr = tc_web
				@diagnose_page.advdiag
			p	@diagnose_page.wan_type.encode("GBK")
			p	@diagnose_page.net_status.encode("GBK")
			p	@diagnose_page.domain_ip.encode("GBK")
			p	@diagnose_page.gw_loss.encode("GBK")
			p	@diagnose_page.dns_parse.encode("GBK")
			p	@diagnose_page.http_code.encode("GBK")
		end
end
