#encoding: utf-8
gem 'minitest'
require 'minitest/autorun'
require 'minitest/reporters'
file_path =File.expand_path('../../lib/router_page_object', __FILE__)
require file_path
# require 'router_page_object'

class Test<MiniTest::Unit::TestCase

    def test_fileshare
        url           = "192.168.100.1"
        usrname       = "admin"
        passwd        = "admin"
        @browser      = Watir::Browser.new :firefox, :profile => "default"
        fileshare_page = RouterPageObject::FilesharePage.new(@browser)
        #登录
        fileshare_page.login_with(usrname, passwd, url)
        ############################################################################

        # fileshare_page.open_fileshare_page(@browser.url)
        # fileshare_page.sdcard
        # fileshare_page.return
        # fileshare_page.udisk
        # p fileshare_page.get_first_catalog_size
        # fileshare_page.first_catalog
        # p fileshare_page.get_second_testfile_size
        # p fileshare_page.second_testfile_element.text
        fileshare_page.close_fileshare(@browser.url)

    end

end