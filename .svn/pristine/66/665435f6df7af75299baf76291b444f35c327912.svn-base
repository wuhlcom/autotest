#encoding: utf-8
gem 'minitest'
require 'minitest/autorun'
require 'minitest/reporters'
file_path =File.expand_path('../../lib/router_page_object', __FILE__)
require file_path
# require 'router_page_object'

class Test<MiniTest::Unit::TestCase


		def test_traffic
				url                 = "192.168.100.1"
				usrname             = "admin"
				passwd              = "admin"
				@tc_bandwidth_total = "10000"
				@tc_rule1_ip1       = "99"
				@tc_rule1_ip2       = ""
				@tc_bandwidth_limit = "500"
				# @tc_bandwidth_limit = ""
				@ts_tag_bandlimit   = "受限最大带宽"
				@ts_tag_bandlimit.encode("utf-8")
				# @ts_tag_bandlimit="\u53D7\u9650\u6700\u5927\u5E26\u5BBD"
				@browser         = Watir::Browser.new :firefox, :profile => "default"
				# systatus_page = RouterPageObject::SystatusPage.new(@browser)
				@options_page    = RouterPageObject::OptionsPage.new(@browser)
				#登录
				@options_page.login_with(usrname, passwd, url)
				@options_page.select_traffic_ctl(@browser.url)
				@options_page.select_traffic_sw
				@options_page.set_total_bw(@tc_bandwidth_total)
				puts "rule 1 ip start ip #{@tc_rule1_ip1},end ip #{@tc_rule1_ip2}"
				@options_page.add_item
				# @options_page.bw_type0 =@ts_tag_bandlimit
				@options_page.set_client_bw(1, @tc_rule1_ip1, @tc_rule1_ip2, @ts_tag_bandlimit, @tc_bandwidth_limit)

		end

end