file_path =File.expand_path('../../lib/htmltags', __FILE__)
require file_path
# require 'htmltags'
class MyTestRouter < MiniTest::Unit::TestCase
	include HtmlTag::WinCmd
	include HtmlTag::LogInOut
	include HtmlTag::Reporter
	# Called before every ftp_test method runs. Can be used
	# to set up fixture information.
	def setup
		# Do nothing
	end

	# Called after every ftp_test method runs. Can be used to tear
	# down fixture information.

	def teardown
		# Do nothing
	end


	def test_lan_onfocus
		@wait_time         =3
		@tag_lan_id        = "set_wifi"
		@tag_lan_iframe_src="lanset.asp"
		@tag_ssid_id       ="ssid"

		@tag_lan_ip_id="lan_ip"
		@tag_mask_id  ="lanNetmask"

		@tag_lan_reset ="aui_content"

		@tag_dhcp_start="dhcpStart"
		@tag_dhcp_end  ="dhcpEnd"
		@tag_lan_reset ="aui_content"

		@tag_net_reset_tip="aui_state_noTitle aui_state_focus aui_state_lock"

		@lan_ip1="172.168.0.1"

		@lan_ip2="10.10.10.1"
		@browser     = Watir::Browser.new :ff, :profile => "default"
		@@default_url="192.168.111.1"
		recover_login(@browser, url=@@default_url, usrname="admin", passwd="admin")
		lanset = @browser.span(:id => @tag_lan_id).wait_until_present(@wait_time)
		@browser.span(:id => @tag_lan_id).click if lanset
		@lan_iframe = @browser.iframe
		# assert_match /#{@tag_lan_iframe_src}/i, @lan_iframe.src, '打开内网设置失败！'
		@lan_iframe.text_field(:id, @tag_lan_ip_id).set(@lan_ip1)
		sleep 2
		p "111111111111111111111"
		p @lan_iframe.text_field(id:@tag_dhcp_start).focus
		p @lan_iframe.text_field(id:@tag_dhcp_start).focused?
		p @lan_iframe.text_field(id:@tag_dhcp_start).value
		p "22222222222222222222222222222"
		p @lan_iframe.text_field(id:@tag_dhcp_start).click
		p @lan_iframe.text_field(id:@tag_dhcp_start).focused?
		p @lan_iframe.text_field(id:@tag_dhcp_start).value
		# p @lan_iframe.text_field(id:@tag_dhcp_start).onfocus
		# dhcp_start_ip = @lan_iframe.text_field(:id, @tag_dhcp_start).value

		# @lan_iframe.text_field(:id, @tag_dhcp_end).click
		# dhcp_end_ip=@lan_iframe.text_field(:id, @tag_dhcp_end).value


		# sub_lan_ip=@lan_ip1.sub(/\.\d+$/, "")
		# assert_match(/#{sub_lan_ip}/, dhcp_start_ip, "ip地址池起始ip未自动修改")
		# assert_match(/#{sub_lan_ip}/, dhcp_end_ip, "ip地址池结束ip未自动修改")
	end
	# Fake ftp_test
	# def test_fail
	#
	# 	fail('Not implemented')
	# end
end