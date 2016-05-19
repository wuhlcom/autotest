#encoding: utf-8
gem 'minitest'
require 'minitest/autorun'
require 'minitest/reporters'
file_path =File.expand_path('../../lib/router_page_object', __FILE__)
require file_path
# require 'router_page_object'

class Test<MiniTest::Unit::TestCase

		def testoptions
				url          = "192.168.100.1"
				usrname      = "admin"
				passwd       = "admin"
				@browser     = Watir::Browser.new :firefox, :profile => "default"
				options_page = RouterPageObject::OptionsPage.new(@browser)
				#登录
				options_page.login_with(usrname, passwd, url)
				options_page.open_options_page(@browser.url)
				options_page.open_apply_page
				sleep 2
				options_page.open_vps_page
				sleep 2
				p options_page.vps_ip_element.value
		end


		def test_web_acc
				url          = "192.168.100.1"
				usrname      = "admin"
				passwd       = "admin"
				@browser     = Watir::Browser.new :firefox, :profile => "default"
				# systatus_page = RouterPageObject::SystatusPage.new(@browser)
				options_page = RouterPageObject::OptionsPage.new(@browser)
				#登录
				options_page.login_with(usrname, passwd, url)
				button = options_page.get_web_accbtn(@browser.url)
				p button.class_name
		end

end