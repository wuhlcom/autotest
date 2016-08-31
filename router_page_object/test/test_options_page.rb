#encoding: utf-8
gem 'minitest'
require 'minitest/autorun'
require 'minitest/reporters'
file_path =File.expand_path('../../lib/router_page_object', __FILE__)
require file_path
# require 'router_page_object'
require 'htmltags'
include HtmlTag::LogInOut

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

        @browser.refresh

        # options_page.open_options_page(@browser.url)
        # p options_page.update?
        # options_page.open_sysset_page
        #
        # p options_page.update?
        # p options_page.login_with_exists(@browser.url)

        options_page.open_security_page_step(@browser.url)
        options_page.mac_filter
        sleep 2
        # p options_page.edit_mac_element.element.style
        # p options_page.mac_display_element.element.style

        options_page.mac_filter_add
        options_page.mac_filter_input("00:11:22:33:44:15", "tc_desc")
        options_page.mac_filter_save
        # p options_page.mac_display_element.element.style_element
        # p options_page.mac_display_element.element.style.exists?
        options_page.mac_filter_add

        error_tip = options_page.mac_items_max_element
        p error_tip.exists?
        error_text = options_page.mac_items_max
        puts "ERROR TIP:#{error_text}".encode("GBK")
        options_page.mac_hint_close #关闭提示框
    end

end