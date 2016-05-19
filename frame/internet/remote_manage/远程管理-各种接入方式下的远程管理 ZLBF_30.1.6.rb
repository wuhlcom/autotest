#
# description:
# dhcp接入方式这里不做验证，有其它脚本已经实现如:远程管理--允许所有主机访问 ZLBF_30.1.1
# author:wuhongliang
# date:2015-11-05 14:00:19
# modify:
#
testcase {
		attr = {"id" => "ZLBF_30.1.6", "level" => "P1", "auto" => "n"}

		def prepare
				DRb.start_service
				@tc_server_obj  = DRbObject.new_with_uri(@ts_drb_server2)
				@tc_static_ip   = "10.10.10.25"
				@tc_static_mask = "255.255.255.0"
				@tc_static_gw   = "10.10.10.1"
				@tc_static_dns  = "10.10.10.1"
		end

		def process

				operate("1、DUT启动，设置WAN接入类型为DHCP，（假设获取到的地址为10.10.0.100）；") {
						#此处不实现
				}

				operate("2、启用远程访问管理功能，访问权限设置为任何人，端口为默认值，查看页面显示的远程管理地址信息是否准确；") {
						#此处不实现
				}

				operate("3、PC2通过WAN口IP地址+设置的远程访问端口号是否能访问到DUT的WEB管理页面；") {
						#此处不实现
				}

				operate("4、修改WAN接入方式为PPPOE，静态接入，PPTP，L2TP，重复步骤2。") {
						@wan_page = RouterPageObject::WanPage.new(@browser)
						puts "设置接入方式为PPPOE".to_gbk
						#修改服务器租约后，WAN要重新获取一次IP地址，这里直接设置DHCP模式并保存
						 @wan_page.set_pppoe(@ts_pppoe_usr, @ts_pppoe_pw, @browser.url)
						sys_page = RouterPageObject::SystatusPage.new(@browser)
						sys_page.open_systatus_page(@browser.url)
						wan_type  = sys_page.get_wan_type
						@wan_addr = sys_page.get_wan_ip
						puts "查询到WAN接入方式为#{wan_type}".to_gbk
						puts "查询到WAN IP为#{@wan_addr}".to_gbk
						assert_match @ts_tag_ip_regxp, @wan_addr, 'PPPOE获取IP地址失败！'
						assert_match /#{@ts_wan_mode_pppoe}/, wan_type, '接入类型错误！'

						@options_page = RouterPageObject::OptionsPage.new(@browser)
						@options_page.open_web_access_btn(@browser.url)
						@tc_web_acc_port = @options_page.web_access_port
						@options_page.save_web_access

						remote_url = "#{@wan_addr}:#{@tc_web_acc_port}"
						puts "Remote Web Login :#{remote_url}"
						rs=@tc_server_obj.login_router(remote_url, @ts_default_usr, @ts_default_pw)
						assert(rs, "远程WEB访问失败!")

						puts "设置接入方式为静态IP".to_gbk
						@wan_page.set_static(@tc_static_ip, @tc_static_mask, @tc_static_gw, @tc_static_dns, @browser.url)
						sys_page.open_systatus_page(@browser.url)
						wan_type  = sys_page.get_wan_type
						@wan_addr = sys_page.get_wan_ip
						puts "查询到WAN接入方式为#{wan_type}".to_gbk
						puts "查询到WAN IP为#{@wan_addr}".to_gbk
						assert_match @ts_tag_ip_regxp, @wan_addr, 'STATIC接入方式设置失败！'
						assert_match /#{@ts_wan_mode_static}/, wan_type, '接入类型错误！'

						remote_url = "#{@wan_addr}:#{@tc_web_acc_port}"
						puts "Remote Web Login :#{remote_url}"
						rs=@tc_server_obj.login_router(remote_url, @ts_default_usr, @ts_default_pw)
						assert(rs, "远程WEB访问失败!")

						puts "设置接入方式为PPTP".to_gbk
						@options_page.set_pptp(@ts_pptp_server_ip, @ts_pptp_usr, @ts_pptp_pw, @browser.url)
						sys_page.open_systatus_page(@browser.url)
						wan_type  = sys_page.get_wan_type
						@wan_addr = sys_page.get_wan_ip
						puts "查询到WAN接入方式为#{wan_type}".to_gbk
						puts "查询到WAN IP为#{@wan_addr}".to_gbk
						assert_match @ts_tag_ip_regxp, @wan_addr, 'pptp接入方式设置失败！'
						assert_match /#{@ts_wan_mode_pptp}/, wan_type, '接入类型错误！'

						remote_url = "#{@wan_addr}:#{@tc_web_acc_port}"
						puts "Remote Web Login :#{remote_url}"
						rs=@tc_server_obj.login_router(remote_url, @ts_default_usr, @ts_default_pw)
						assert(rs, "远程WEB访问失败!")
				}


		end

		def clearup

				operate("1,关闭远程访问功能") {
				    @options_page = RouterPageObject::OptionsPage.new(@browser)
				    @options_page.close_web_access(@browser.url)
				}

				operate("2.恢复默认DHCP接入") {
				    wan_page = RouterPageObject::WanPage.new(@browser)
				    wan_page.set_dhcp(@browser, @browser.url)
				}
		end

}
