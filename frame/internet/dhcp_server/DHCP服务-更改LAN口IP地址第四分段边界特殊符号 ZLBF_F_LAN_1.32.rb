#
#description:
#author:wuhongliang
#date:2015-06-30 14:12:41
#modify:
#
testcase {
		attr = {"id" => "ZLBF_6.1.4", "level" => "P1", "auto" => "n"}

		def prepare
				@tc_ipaddr_error = "IP地址格式错误"
				@tc_lan_ip1      = "192.168.100. 1"
				@tc_lan_ip2      = "192.168.100.1 2"
				@tc_lan_ip3      = "192.168.100.1 "
				@tc_lan_ip4      = "192.168.100.*"
				@tc_lan_ip5      = "192.168.100.r"
				@tc_lan_ip6      = "192.168.100.-1"
				@tc_lan_ip7      = "192.168.100.测"
				@tc_flag         = false
		end

		def process

				operate("1、登陆路由器进入内网设置") {
						@lan_page = RouterPageObject::LanPage.new(@browser)
						@lan_page.open_lan_page(@browser.url)
				}

				operate("2、分别更改DHCP服务地址为，如192.168.100.%，192.168.100.好,192.168.100.空格,192.168.100.空格1,192.168.100.1空格，192.168.100.-1等特殊符号") {
						puts "修改LAN DHCP服务IP为#{@tc_lan_ip1}".to_gbk
						@lan_page.lan_ip_set(@tc_lan_ip1)
						@lan_page.save_lanset
						error_msg = @lan_page.lan_error
						puts "ERROR TIP:#{error_msg}".to_gbk
						unless @tc_ipaddr_error==error_msg
								@tc_flag=true
						end
						assert_equal(@tc_ipaddr_error, error_msg, "未提示IP地址格式错误")

						puts "修改LAN DHCP服务IP为#{@tc_lan_ip2}".to_gbk
						@lan_page.lan_ip_set(@tc_lan_ip2)
						@lan_page.save_lanset
						error_msg = @lan_page.lan_error
						puts "ERROR TIP:#{error_msg}".to_gbk
						unless @tc_ipaddr_error==error_msg
								@tc_flag=true
						end
						assert_equal(@tc_ipaddr_error, error_msg, "未提示IP地址格式错误")

						puts "修改LAN DHCP服务IP为#{@tc_lan_ip3}".to_gbk
						@lan_page.lan_ip_set(@tc_lan_ip3)
						@lan_page.save_lanset
						error_msg = @lan_page.lan_error
						puts "ERROR TIP:#{error_msg}".to_gbk
						unless @tc_ipaddr_error==error_msg
								@tc_flag=true
						end
						assert_equal(@tc_ipaddr_error, error_msg, "未提示IP地址格式错误")

						puts "修改LAN DHCP服务IP为#{@tc_lan_ip4}".to_gbk
						@lan_page.lan_ip_set(@tc_lan_ip4)
						@lan_page.save_lanset
						error_msg = @lan_page.lan_error
						puts "ERROR TIP:#{error_msg}".to_gbk
						unless @tc_ipaddr_error==error_msg
								@tc_flag=true
						end
						assert_equal(@tc_ipaddr_error, error_msg, "未提示IP地址格式错误")

						puts "修改LAN DHCP服务IP为#{@tc_lan_ip5}".to_gbk
						@lan_page.lan_ip_set(@tc_lan_ip5)
						@lan_page.save_lanset
						error_msg = @lan_page.lan_error
						puts "ERROR TIP:#{error_msg}".to_gbk
						unless @tc_ipaddr_error==error_msg
								@tc_flag=true
						end
						assert_equal(@tc_ipaddr_error, error_msg, "未提示IP地址格式错误")

						puts "修改LAN DHCP服务IP为#{@tc_lan_ip6}".to_gbk
						@lan_page.lan_ip_set(@tc_lan_ip6)
						@lan_page.save_lanset
						error_msg = @lan_page.lan_error
						puts "ERROR TIP:#{error_msg}".to_gbk
						unless @tc_ipaddr_error==error_msg
								@tc_flag=true
						end
						assert_equal(@tc_ipaddr_error, error_msg, "未提示IP地址格式错误")

						puts "修改LAN DHCP服务IP为#{@tc_lan_ip7}".to_gbk
						@lan_page.lan_ip_set(@tc_lan_ip7)
						@lan_page.save_lanset
						error_msg = @lan_page.lan_error
						puts "ERROR TIP:#{error_msg}".to_gbk
						unless @tc_ipaddr_error==error_msg
								@tc_flag=true
						end
						assert_equal(@tc_ipaddr_error, error_msg, "未提示IP地址格式错误")
				}

				operate("3、分别保存，客户端是否自动获取IP地址为更改网段的IP地址、子网掩码、网关、DNS服务器信息") {
				}

		end

		def clearup
				operate("1 恢复默认DHCP服务IP") {
						if @tc_flag
								sleep 80
						end
				}

		end

}
