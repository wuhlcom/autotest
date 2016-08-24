#encoding: utf-8
gem 'minitest'
require 'minitest/autorun'
require 'minitest/reporters'
file_path =File.expand_path('../../lib/router_page_object', __FILE__)
require file_path
# require 'router_page_object'

class Test<MiniTest::Unit::TestCase

		def test_ap
				url               = "192.168.50.1"
				mode              ="802.11b/g/n"
				channel           ="2"
				bandwidth         ="Auto 20/40M"
				safe              ="WPA-PSK(TKIP)"
				@browser          = Watir::Browser.new :firefox, :profile => "default"
				@accompany_router = RouterPageObject::AccompanyRouter.new(@browser)
				#登录
				@accompany_router.login_accompany_router(url)
				@accompany_router.open_wireless_24g_page
				@accompany_router.input_24g_options(mode, channel, bandwidth, safe)
				# @accompany_router.browser.execute_script("window.confirm = function() {return true}")
				# @accompany_router.ap_save
				# @accompany_router.confirm
				 @accompany_router.ap_save_config
		end

end