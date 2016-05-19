#
# description:
# pc2 远程登录暂未实现
# author:wuhongliang
# date:2015-08-26 11:47:04
# modify:
#
testcase {
		attr = {"id" => "ZLBF_30.1.1", "level" => "P1", "auto" => "n"}

		def prepare
				DRb.start_service
				@tc_server_obj = DRbObject.new_with_uri(@ts_drb_server2)
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
				}

				operate("2、启用远程访问管理功能，访问权限设置为任何人，端口为默认值，查看页面显示的远程管理地址信息是否准确；") {
						@options_page = RouterPageObject::OptionsPage.new(@browser)
						@options_page.open_web_access_btn(@browser.url)
						@tc_web_acc_port = @options_page.web_access_port
						@options_page.save_web_access
				}

				operate("3、PC2通过WAN口IP地址+设置的远程访问端口号是否能访问到DUT的WEB管理页面（注意登录认证对话框等显示字符的合法/正确性，如不能显示异常字符图片或不符合当前客户的字符图片）；") {
						remote_url = "#{@wan_addr}:#{@tc_web_acc_port}"
						puts "Remote Web Login :#{remote_url}"
						rs=@tc_server_obj.login_router(remote_url, @ts_default_usr, @ts_default_pw)
						assert(rs, "远程WEB访问失败!")
				}

				operate("4、测试网上另一台主机PC3通过WAN口IP地址+设置的远程访问端口号是否能访问到DUT的WEB管理页面；") {
						#pending
				}

				operate("5、PC2通过WAN口IP地址+非设置的远程访问端口号是否能访问到DUT的WEB管理页面。") {
						remote_url = "#{@wan_addr}:#{@tc_web_acc_port.succ!}"
						puts "Remote Web Login :#{remote_url}"
						rs=@tc_server_obj.login_router(remote_url, @ts_default_usr, @ts_default_pw)
						refute(rs, "错误的端口也能远程WEB访问!")
				}

		end

		def clearup
				operate("1 关闭外网访问WEB功能") {
						@options_page = RouterPageObject::OptionsPage.new(@browser)
						@options_page.close_web_access(@browser.url)
				}
		end

}
