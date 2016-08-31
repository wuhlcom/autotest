#encoding: utf-8
gem 'minitest'
require 'minitest/autorun'
require 'minitest/reporters'
file_path =File.expand_path('../../lib/router_page_object', __FILE__)
require file_path
# require 'router_page_object'

class Test<MiniTest::Unit::TestCase

    def test_systatus
        url           = "192.168.100.1"
        usrname       = "admin"
        passwd        = "admin"
        @browser      = Watir::Browser.new :firefox, :profile => "default"
        wifidetail_page = RouterPageObject::WIFIDetail.new(@browser)
        #登录
        wifidetail_page.login_with(usrname, passwd, url)
        wifidetail_page.open_wifidetail_page(@browser.url)

        p wifidetail_page.table_obj.element.trs[1][1].text
        p wifidetail_page.ssid1_name


    end

end