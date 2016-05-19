#
# description:
# author:wuhongliang
# date:2016-03-12 11:25:32
# modify:
#
testcase {
		attr = {"id" => "ZLBF_ApMode_1.1.3", "level" => "P3", "auto" => "n"}

		def prepare		
				@tc_static_args = {nicname: @ts_nicname, source: "static", ip: "192.168.100.15", mask: "255.255.255.0", gateway: @ts_default_ip}
				@tc_dhcp_args   = {nicname: @ts_nicname, source: "dhcp"}
				@tc_root_usr    = "root"
				@tc_root_pw     = "zl4321"
				@tc_wan_intf    = "eth0.2"
		end

		def process

				operate("1、PC1连接DUT的Lan口，动态获取地址，查看是否能获取DUT分配的地址；") {
						@mode_page = RouterPageObject::ModePage.new(@browser)
						@mode_page.save_apmode(@browser.url)
				}

				operate("2、PC2通过无线连接DUT，动态获取地址，查看是否能获取DUT分配的地址；") {
						netsh_if_ip_setip(@tc_dhcp_args)
						#网卡重新获取IP地址
						ip_release
						ip_renew
						rs        = ipconfig
						pc_ip_arr = rs[@ts_nicname][:ip]
						puts "PC IP address:#{pc_ip_arr}"
						pc_ip = pc_ip_arr[0]
						flag  =false
						flag  =true if pc_ip_arr.empty? || pc_ip=~/^169|10\.10\.10/ #如果PC未获得地址或获取上层的址则说明DHCP被关
						assert(flag, "AP模式未关闭DHCP")
				}

				operate("3、DUT的Wan口连接上行AP的Lan口，查看Wan口是否能获取上行AP分配的地址；") {
						#配置静态IP
						netsh_if_ip_setip(@tc_static_args)
						#查询路由器原WAN口是否有IP地址,AP模式路由器原WAN应该无IP地址
						init_router_obj(@ts_default_ip, @tc_root_usr, @tc_root_pw)
						rs = router_ifconfig(@tc_wan_intf)
						p "wan ifconfig result:#{rs}"
						#查询WAN口状态
						refute(rs.has_key?(:ip), "路由器WAN口未切换成LAN")
				}


		end

		def clearup

				operate("1.恢复默认设置") {
						netsh_if_ip_setip(@tc_static_args)
						@mode_page = RouterPageObject::ModePage.new(@browser)
						@mode_page.login_mode_change(@ts_default_usr, @ts_default_pw, @ts_default_ip) #重新登录
						@mode_page.open_mode_page(@browser.url)
						unless @mode_page.routermode_selected?
								@mode_page.set_router_mode
						end
						#动态IP
						netsh_if_ip_setip(@tc_dhcp_args)
				}

		end

}
