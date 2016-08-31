#encoding: utf-8
gem 'minitest'
require 'minitest/autorun'
require 'minitest/reporters'
file_path =File.expand_path('../../lib/router_page_object', __FILE__)
require file_path

class Test<MiniTest::Unit::TestCase

    def test_systatus
        url            = "192.168.100.1"
        usrname        = "admin"
        passwd         = "admin"
        @browser       = Watir::Browser.new :firefox, :profile => "default"
        @diagnose_page = RouterPageObject::DiagnoseAdvPage.new(@browser)
        @diagnose_page.login_with(usrname, passwd, url)
        ##############################################################################################
        @diagnose_page.initialize_diagadv(@browser)
        # @diagnose_page.switch_page(1) #切换到诊断窗口
        # @diagnose_page.url_addr = "http://www.zhilu.com "
        # sleep 1
        # @diagnose_page.advdiag(30)
        # p rs = @diagnose_page.wan_type
        # # p rs.encode("GBK")
        # # p rs.slice(/\(.+\)\s*:(.+)/, 1)
        # # p rs.slice(/\p{Han}(.+)/, 1)
        # p "1111" if rs =~ /dhcp/i
        # p ts = @diagnose_page.net_status
        # p "22222" if ts =~ /正常/i
        #
        # # p @diagnose_page.wan_conn.encode("GBK")
        # # p @diagnose_page.cpu_status

    end

end