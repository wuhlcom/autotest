#encoding: utf-8
gem 'minitest'
require 'minitest/autorun'
require 'minitest/reporters'
file_path =File.expand_path('../../lib/router_page_object', __FILE__)
require file_path

class Test<MiniTest::Unit::TestCase

    def test_accompany
        url       = "192.168.50.1"
        @browser  = Watir::Browser.new :firefox, :profile => "default"
        accompany_router = RouterPageObject::AccompanyRouter.new(@browser)
        accompany_router.login_accompany_router(url)

        # accompany_router.open_status_page
        accompany_router.open_wireless_24g_page
        # p accompany_router.get_lan_ip(@browser.url)
        # accompany_router.open_wireless_24g_page(@browser.url)

        # accompany_router.ap_reboot(@browser, url)

        # p accompany_router.ap_wireless_bandwidth_element.disabled?
        #
        #
        # @tc_ap_wireless_pattern_value   = "802.11b/g/n"
        # @tc_ap_channel_value            = "6"
        # @tc_ap_bandwidth_value          = "Auto 20/40M"
        # @tc_ap_safe_option_value        = "WPA2-PSK(AES)"
        # accompany_router.wireless_24g_options(@browser, @tc_ap_wireless_pattern_value, @tc_ap_channel_value, @tc_ap_bandwidth_value, @tc_ap_safe_option_value)
        p accompany_router.get_wan_mac
    end
end