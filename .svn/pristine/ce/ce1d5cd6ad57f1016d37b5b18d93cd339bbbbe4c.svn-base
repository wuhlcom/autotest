#encoding: utf-8
gem 'minitest'
require 'minitest/autorun'
require 'minitest/reporters'
file_path =File.expand_path('../../lib/router_page_object', __FILE__)
require file_path
# require 'router_page_object'

class Test<MiniTest::Unit::TestCase

		def test_systatus
				url      = "192.168.100.1"
				usrname  = "admin"
				passwd   = "admin"
				@browser = Watir::Browser.new :firefox, :profile => "default"

				options_page = RouterPageObject::OptionsPage.new(@browser)
				options_page.login_with(usrname, passwd, url)
				options_page.open_options_page(@browser.url)
				options_page.close_options_page
				# options_page.select_pptp(@browser.url)
				# options_page.security_settings
				# options_page.firewall
				# options_page.firewall_switch
				# options_page.apply_settings
				# options_page.dmz
				# options_page.dmz_switch

				# options_page.recover_factory(@browser.url)

		end

end