#encoding: utf-8
gem 'minitest'
require 'minitest/autorun'
require 'minitest/reporters'
file_path =File.expand_path('../../lib/router_page_object', __FILE__)
require file_path
# require 'router_page_object'

class Test<MiniTest::Unit::TestCase
    def testreboot
        url      = "192.168.100.1"
        usrname  = "admin"
        passwd   = "admin"
        @browser = Watir::Browser.new :firefox, :profile => "default"
        operate  = RouterPageObject::LanPage.new(@browser)
        #登录
        operate.login_with(usrname, passwd, url)
        #设置dhcp
        operate.reboot
    end

    def test_lan_click
        @@ts_tag_lan_src = "lanset.asp"
        url              = "192.168.100.1"
        usrname          = "admin"
        passwd           = "admin"
        @browser         = Watir::Browser.new :firefox, :profile => "default"
        operate          = RouterPageObject::LanPage.new(@browser)
        #登录
        operate.login_with(usrname, passwd, url)
        # operate.lan_span_obj.click
        # @browser.iframe(src: @@ts_tag_lan_src).exists?
        # p operate.in_iframe(src: @@ts_tag_lan_src).exists?

        p operate.dev_list?
        p operate.dev_list_element.parent.em_element.text
        p operate.dev_list_element.parent.em_element.text.nil?
        p operate.dev_list_element.parent.em_element.text.empty?
        p "============="
        p operate.sys_version?
        rs = operate.sys_version
        p rs.slice(/V\d+R\d+C.+/i)
        p rs.slice(/V\d+R\d+C.+/i).nil?
        p rs.slice(/V\d+R\d+C.+/i).empty?
        p operate.advance?

        operate.reboot(80)
        if @browser.text_field(:name, 'admuser').exists?
            # @browser.text_field(:name, 'admuser').click
            @browser.text_field(:name, 'admuser').set(usrname)
            sleep 1
            # @browser.text_field(:name, 'admpass').click
            @browser.text_field(:name, 'admpass').set(passwd)
            sleep 1
            @browser.button(:id, 'submit_btn').click
            sleep 3
        end
        p "**********************************************************************"
        p operate.dev_list?
        p operate.dev_list_element.parent.em_element.text
        p operate.dev_list_element.parent.em_element.text.nil?
        p operate.dev_list_element.parent.em_element.text.empty?
        p "============="
        p operate.sys_version?
        rs = operate.sys_version
        p rs.slice(/V\d+R\d+C.+/i)
        p rs.slice(/V\d+R\d+C.+/i).nil?
        p rs.slice(/V\d+R\d+C.+/i).empty?
        p operate.advance?
    end
end
