#encoding: utf-8
gem 'minitest'
require 'minitest/autorun'
require 'minitest/reporters'
require 'htmltags'
include HtmlTag::WinCmd
file_path =File.expand_path('../../lib/router_page_object', __FILE__)
require file_path
# require 'router_page_object'

class Test<MiniTest::Unit::TestCase

    def test_devlist
        url      = "192.168.100.1"
        usrname  = "admin"
        passwd   = "admin"
        @browser = Watir::Browser.new :firefox, :profile => "default"
        operate  = RouterPageObject::DevlistPage.new(@browser)
        #登录
        operate.login_with(usrname, passwd, url)
        sleep 2
        # p size = operate.get_dev_size

        # p mac = ipconfig("all")["dut"][:mac].downcase
        # operate.open_devlist_page
        # p operate.get_data(size, mac)


       # p operate.dev_list_element.parent.em_element.text

        p dev_size      = operate.get_dev_size #连接设备数
        operate.open_devlist_page
        p dev_data = operate.get_data(dev_size, "bc-ee-7b-75-eb-4f")
        p dev_ip   = dev_data[:ip]

    end

end
