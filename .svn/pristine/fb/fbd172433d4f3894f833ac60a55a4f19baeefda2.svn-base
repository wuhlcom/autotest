#
# description:
# 切换AP模式后WAN转成LAN口
# 所以这里只要测试切AP模式后，PC能从上层获取到IP地址即可
# author:wuhongliang
# date:2016-03-12 11:25:32
# modify:
#
testcase {
		attr = {"id" => "ZLBF_ApMode_1.1.4", "level" => "P1", "auto" => "n"}

		def prepare
				@tc_static_args = {nicname: @ts_nicname, source: "static", ip: "192.168.100.15", mask: "255.255.255.0", gateway: @ts_default_ip}
				@tc_dhcp_args   = {nicname: @ts_nicname, source: "dhcp"}
		end

		def process

				operate("1、PC1连接DUT的其他Lan口，动态获取地址，查看是否获取的是上行AP分配的地址；") {
						@mode_page = RouterPageObject::ModePage.new(@browser)
						@mode_page.save_apmode(@browser.url)
						#配置静态IP
						netsh_if_ip_setip(@tc_static_args)
						@mode_page.login_mode_change(@ts_default_usr, @ts_default_pw, @ts_default_ip) #重新登录
						netsh_if_ip_setip(@tc_dhcp_args)
						#网卡重新获取IP地址
						ip_release
						ip_renew
						rs        = ipconfig
						pc_ip_arr = rs[@ts_nicname][:ip]
						puts "PC IP address:#{pc_ip_arr}"
						pc_ip = pc_ip_arr[0]
						flag  = false
						flag  = true if pc_ip=~/^10\.10\.10/ #如果PC未获得地址或获取上层的址则说明DHCP被关
						assert(flag, "PC未从上层服务获取到IP地址")
				}

				# operate("2、PC1连接DUT的Wan口，动态获取地址，查看是否能获取上行AP分配的地址；") {
				operate("2、查看能否连接外网") {
						rs = ping(@ts_web)
						assert(rs, "PC无法连接外网")
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
