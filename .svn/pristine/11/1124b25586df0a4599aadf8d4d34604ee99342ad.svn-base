#
#description:
#author:wuhongliang
#date:2015-06-30 14:12:40
#modify:
#
testcase {
	attr = {"id" => "ZLBF_5.1.23", "level" => "P1", "auto" => "n"}

	def prepare
		@tc_wait_time = 3
		@tc_wait_login= 60

		@tc_tag_lan_mac   = "LAN-MAC"
		@tc_tag_lan_ip    = "LAN-IP"
		@tc_tag_lan_ip_id = "lan_ip"
		@tc_tag_lan_mask  = "LAN-NETMASK"

		@tc_tag_dhcp_start = "dhcpStart"
		@tc_tag_dhcp_end   = "dhcpEnd"

		@tc_lan_ip = "192.168.121.1"

	end

	def process

		operate("1 打开状态界面") {
			@browser.span(:id => @ts_tag_status).click
			@status_iframe = @browser.iframe
			assert_match /#{@ts_tag_status_iframe_src}/i, @status_iframe.src, "打开界面失败!"
		}

		operate("2 查看lan状态") {
			rs_mac = @status_iframe.b(id: @tc_tag_lan_mac).parent.text
			rs_ip  = @status_iframe.b(id: @tc_tag_lan_ip).parent.text
			rs_mask= @status_iframe.b(id: @tc_tag_lan_mask).parent.text
			assert_match(@ts_wan_mac_pattern1, rs_mac, "显示mac地址错误!")
			assert_match(/#{@ts_default_ip}/, rs_ip, "显示ip地址错误!")
			assert_match(/#{@ts_lan_mask}/, rs_mask, "显示mask地址错误!")
		}

		operate("3 修改LAN IP地址") {
			@browser.span(:id => @ts_tag_lan).click
			@lan_iframe = @browser.iframe
			@lan_iframe.text_field(:id, @tc_tag_lan_ip_id).set(@tc_lan_ip)
			sleep 3
			@lan_iframe.text_field(:id, @tc_tag_dhcp_end).focus
			@lan_iframe.text_field(:id, @tc_tag_dhcp_end).focus
			@lan_iframe.button(:id, @ts_tag_sbm).click

			#<div class="aui_content" style="padding: 20px 25px;">设置成功，请稍候......重置网络，如果网络断连，请重新连接。</div>
			Watir::Wait.until(@tc_wait_time, "等待重启LAN提示出现失败".to_gbk) {
				lan_reseting = @lan_iframe.div(class_name: @ts_tag_lan_reset,text:@ts_tag_lan_reset_text)
				lan_reseting.present?
			}

			rs = @browser.text_field(:name, @usr_text_id).wait_until_present(@tc_wait_login)
			assert rs, '跳转到登录页面失败！'
			#重新登录路由器
			login_no_default_ip(@browser)
		}

		operate("4 修改LAN IP后重新查看LAN状态") {
			@browser.span(:id => @ts_tag_status).click
			@status_iframe = @browser.iframe
			rs_mac         = @status_iframe.b(id: @tc_tag_lan_mac).parent.text
			rs_ip          = @status_iframe.b(id: @tc_tag_lan_ip).parent.text
			rs_mask        = @status_iframe.b(id: @tc_tag_lan_mask).parent.text
			assert_match(@ts_wan_mac_pattern1, rs_mac, "修改设置显示mac地址错误!")
			assert_match(/#{@tc_lan_ip}/, rs_ip, "修改设置显示ip地址错误!")
			assert_match(/#{@ts_lan_mask}/, rs_mask, "修改设置显示mask地址错误!")
		}

	end

	def clearup
		operate("1 恢复Lan默认配置") {
			rs1 = ping(@ts_default_ip)
			if rs1 == true
				puts "路由器已是默认配置".to_gbk
			else
				login_recover(@browser, @ts_default_ip)
			end
		}
	end

}
