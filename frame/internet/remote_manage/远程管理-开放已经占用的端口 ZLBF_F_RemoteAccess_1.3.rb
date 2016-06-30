#
# description:
# 1.虚拟服务器与外网访问的端口相同时，外网访问优先
# author:wuhlcom
# date:2015-11-05 14:00:19
# modify:
#
testcase {
		attr = {"id" => "ZLBF_30.1.3", "level" => "P2", "auto" => "n"}

		def prepare
				DRb.start_service
				@tc_server_obj   = DRbObject.new_with_uri(@ts_drb_server2)
				@tc_dut_ip       = ipconfig("all")[@ts_nicname][:ip][0] #获取dut网卡ip
				@tc_wait_time    = 3
				@tc_private_port = "80"
				@tc_content      = "HTTP AutoTest"

		end

		def process

				operate("1、DUT启动，设置WAN接入类型为DHCP，（假设获取到的地址为10.10.0.100）；") {
						@wan_page = RouterPageObject::WanPage.new(@browser)
						puts "设置接入方式为DHCP".to_gbk
						#修改服务器租约后，WAN要重新获取一次IP地址，这里直接设置DHCP模式并保存
						@wan_page.set_dhcp(@browser, @browser.url)
						sys_page = RouterPageObject::SystatusPage.new(@browser)
						sys_page.open_systatus_page(@browser.url)
						wan_type  = sys_page.get_wan_type
						@wan_addr = sys_page.get_wan_ip
						puts "查询到WAN接入方式为#{wan_type}".to_gbk
						puts "查询到WAN IP为#{@wan_addr}".to_gbk
						assert_match @ts_tag_ip_regxp, @wan_addr, 'dhcp获取ip地址失败！'
						assert_match /#{@ts_wan_mode_dhcp}/, wan_type, '接入类型错误！'
						if @browser.div(class_name: @ts_aui_state_focus).exists? || @browser.div(class_name: @ts_aui_state).exists?
								@browser.execute_script(@ts_close_div)
						end
				}

				operate("2、启用远程访问管理功能，访问权限设置为任何人，端口为默认值") {
						@options_page = RouterPageObject::OptionsPage.new(@browser)
						@options_page.open_web_access_btn(@browser.url)
						@tc_web_acc_port = @options_page.web_access_port
						@options_page.save_web_access(15)
				}

				operate("3、PC2通过WAN口IP地址+设置的远程访问端口号是否能访问到DUT的WEB管理页面；") {
						remote_url = "#{@wan_addr}:#{@tc_web_acc_port}"
						puts "Remote Web Login :#{remote_url}"
						rs=@tc_server_obj.login_router(remote_url, @ts_default_usr, @ts_default_pw)
						assert(rs, "远程WEB访问失败!")
				}

				operate("4、启用虚拟服务器功能，添加规则，转发端口设置为2000-3000，保存配置；") {
						puts "虚拟服务器IP为#{@tc_dut_ip},对外端口#{@tc_web_acc_port},服务器端口#{@tc_private_port}".to_gbk
						@options_page.open_vps_step(@browser.url)
						@options_page.add_vps
						@options_page.vps_input(@tc_dut_ip, @tc_web_acc_port, @tc_private_port)
						@options_page.save_vps
				}

				operate("5、修改远程访问管理端口为2000-3000之间的任意端口，是否能设置成功；") {
						puts "开启虚拟服务器".to_gbk
						http_server(@wan_addr, @tc_private_port, @tc_content)
						rs = @tc_server_obj.tcp_client(@wan_addr, @tc_web_acc_port)
						refute(rs.tcp_state, "外网与虚拟服务器使用同一端口时虚拟服务器不能访问")
				}


		end

		def clearup

				operate("1,关闭远程访问功能") {
						@options_page = RouterPageObject::OptionsPage.new(@browser)
						@options_page.close_web_access(@browser.url)
				}

				operate("2,删除虚拟服务器配置") {
						@options_page.open_vps_step(@browser.url)
						@options_page.delete_all_vps
						@options_page.close_vps_btn
						@options_page.save_vps
				}

		end

}
