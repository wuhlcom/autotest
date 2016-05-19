#
# description:
# author:wuhongliang
# date:2015-08-26 11:47:04
# modify:
#
testcase {
		attr = {"id" => "ZLBF_30.1.2", "level" => "P1", "auto" => "n"}

		def prepare
				DRb.start_service
				@tc_server_obj          = DRbObject.new_with_uri(@ts_drb_server2)
				@tc_tag_remote_p1       = 65534
				@tc_tag_remote_p2       = 9001
		end

		def process

				operate("1、DUT启动，设置WAN接入类型为DHCP，（假设获取到的地址为10.10.0.100）；                                                               2、启用远程访问管理功能，访问权限设置为任何人，端口设置为1，查看页面显示的远程管理地址信息是否准确；") {
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
				}

				operate("2、启用远程访问管理功能，端口为#{@tc_tag_remote_p1}，查看页面显示的远程管理地址信息是否准确；") {
						@options_page = RouterPageObject::OptionsPage.new(@browser)
						@options_page.open_web_access_btn(@browser.url)
						@options_page.web_access_port=@tc_tag_remote_p1
						@options_page.save_web_access
				}

				operate("3、启用远程访问管理功能，PC通过WAN口IP地址#{@wan_addr}+设置的远程访问端口号#{@tc_tag_remote_p1}是否能访问到DUT的WEB管理页面；") {
						remote_url = "#{@wan_addr}:#{@tc_tag_remote_p1}"
						puts "Remote Web Login :#{remote_url}"
						rs=@tc_server_obj.login_router(remote_url, @ts_default_usr, @ts_default_pw)
						assert(rs, "远程WEB访问失败!")
				}

				operate("4、启用远程访问管理功能，PC通过WAN口IP地址#{@wan_addr}+默认远程端口号#{@ts_remote_default_port}是否能访问到DUT的WEB管理页面；") {
						remote_url = "#{@wan_addr}:#{@ts_remote_default_port}"
						puts "Remote Web Login :#{remote_url}"
						rs=@tc_server_obj.login_router(remote_url, @ts_default_usr, @ts_default_pw)
						refute(rs, "修改端口为非默认后,使用默认端口也能远程WEB访问!")
				}

				operate("5、启用远程访问管理功能，端口为#{@tc_tag_remote_p2}，查看页面显示的远程管理地址信息是否准确；") {
						@options_page.web_access_port=@tc_tag_remote_p2
						@options_page.save_web_access
				}

				operate("6、启用远程访问管理功能，PC通过WAN口IP地址#{@wan_addr}+设置的远程访问端口号#{@tc_tag_remote_p2}是否能访问到DUT的WEB管理页面；") {
						remote_url = "#{@wan_addr}:#{@tc_tag_remote_p2}"
						puts "Remote Web Login :#{remote_url}"
						rs=@tc_server_obj.login_router(remote_url, @ts_default_usr, @ts_default_pw)
						assert(rs, "远程WEB访问失败!")
				}

		end

		def clearup
				operate("1 关闭外网访问WEB功能") {
						@options_page = RouterPageObject::OptionsPage.new(@browser)
						@options_page.close_web_access(@browser.url)
				}
		end

}
