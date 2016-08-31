#encoding: utf-8
gem 'minitest'
require 'minitest/autorun'
require 'minitest/reporters'
file_path =File.expand_path('../../lib/router_page_object', __FILE__)
require file_path
# require 'router_page_object'

class Test<MiniTest::Unit::TestCase

    def test_wifipage
        url      = "192.168.100.1"
        usrname  = "admin"
        passwd   = "admin"
        @browser = Watir::Browser.new :firefox, :profile => "default"

        @wifi_page = RouterPageObject::WIFIPage.new(@browser)
        @wifi_page.login_with(usrname, passwd, url)
        # @wifi_page.open_wifi_page(@browser.url)
        ###############################################################


        rs_wifi    = @wifi_page.modify_ssid_mode_pwd(@browser.url)
        p @dut_ssid  = rs_wifi[:ssid]
        p @dut_pwd   = rs_wifi[:pwd]








    end
end