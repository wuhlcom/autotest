#
# description:
# # 备注：续约时间为租约时间的一半。
# author:liluping
# date:2015-11-05 14:00:18
# modify:
#
testcase {
		attr = {"id" => "ZLBF_6.1.3", "level" => "P2", "auto" => "n"}

		def prepare
				@tc_dumpcap_server         = DRbObject.new_with_uri(@ts_drb_server2)
				@tc_lease_time             = "120" #抓包时间
				@tc_dhcp_server_ip         = "10.10.10.1"
				@tc_dhcp_lease_set         = "ip dhcp-server set lease-time=00:01:00 numbers=DHCP-server" #修改租约为1分钟
				@tc_dhcp_lease_default_set = "ip dhcp-server set lease-time=1d numbers=DHCP-server" #默认为一天
				@tc_dhcp_pri               = "ip dhcp-server pri"
		end

		def process

				operate("1、修改服务器租约时间；") {
						@tc_dumpcap_server.init_routeros_obj(@ts_server_ip)
						@tc_dumpcap_server.routeros_send_cmd(@tc_dhcp_lease_set) #设置租约为1分钟
						rs = @tc_dumpcap_server.dhcp_srv_pri(@tc_dhcp_pri)
						p "修改服务器DHCP-server的租约时间为:#{rs["lease-time"]}".to_gbk
				}

				operate("2、DUT上配置相应的DHCPC 方式接入配置，查看DUT是否可以获取到DHCP Server配置的相关地址信息等；") {
						@wan_page = RouterPageObject::WanPage.new(@browser)
						puts "设置接入方式为DHCP".to_gbk
						#修改服务器租约后，WAN要重新获取一次IP地址，这里直接设置DHCP模式并保存
						@wan_page.set_dhcp_mode(@browser.url)
						sys_page = RouterPageObject::SystatusPage.new(@browser)
						sys_page.open_systatus_page(@browser.url)
						@wan_mac = sys_page.get_wan_mac
						wan_type = sys_page.get_wan_type
						wan_addr = sys_page.get_wan_ip
						mask     = sys_page.get_wan_mask
						gateway  = sys_page.get_wan_gw
						dns      = sys_page.get_wan_dns
						puts "查询到WAN MAC为#{@wan_mac}".to_gbk
						puts "查询到WAN接入方式为#{wan_type}".to_gbk
						puts "查询到WAN IP为#{wan_addr}".to_gbk
						puts "查询到WAN 掩码为#{mask}".to_gbk
						puts "查询到WAN 网关为#{gateway}".to_gbk
						puts "查询到WAN DNS为#{dns}".to_gbk
						assert_match @ts_tag_ip_regxp, wan_addr, 'dhcp获取ip地址失败！'
						assert_match /#{@ts_wan_mode_dhcp}/, wan_type, '接入类型错误！'
						assert_match @ts_tag_ip_regxp, mask, 'dhcp获取ip地址掩码失败！'
						assert_match @ts_tag_ip_regxp, gateway, 'dhcp获取网关ip地址失败！'
						assert_match @ts_tag_ip_regxp, dns, 'dhcp获取dns ip地址失败！'
				}

				operate("3、在LAN PC上执行ping dhcp server IP -t；") {
						@thread = Thread.new do
								rs = ping_lost_pack(@tc_dhcp_server_ip, 150)
								# assert(rs, "PC上ping dhcp server IP 不通")
								assert(rs<1, "pc在ping过程中有丢包现象")
								p "ping执行结束，无丢包现象！".to_gbk
						end

				}

				operate("4、等待3分钟后，查看DUT是否发request报文，请求续约IP地址，续约间隔是否正常，PC PING是否有丢包现像；") {
						p "查看DUT是否发request报文".to_gbk
						@tc_cap_fields = "-e frame.time_relative" #查看发送报文时所用的时间
						@tc_cap_filter = "bootp.type==1&&eth.src==#{@wan_mac}" #约束条件为: request报文并且进行mac地址约束
						args           = {nic: @ts_server_lannic, filter: @tc_cap_filter, duration: @tc_lease_time, fields: @tc_cap_fields}
						ts             = @tc_dumpcap_server.tshark_display_filter_fields(args).last(2)
						puts ts
						assert(!ts.empty?, "未抓取到包！")
						request_time2 = ts[1].slice(/->(.+)/, 1).to_i
						request_time1 = ts[0].slice(/->(.+)/, 1).to_i
						puts "两次request报文时间点分别是：#{request_time1}s,和 #{request_time2}s".to_gbk
						flag  = false
						value =request_time2-request_time1
						puts "DHCP服务器租期为60s时，路由器WAN发送request的间隔为#{value}".to_gbk
						if (value>= 30 && value <= 33) #因为路由器续约前发送ARP报文,dhcp续约报文会延迟2-3s发送，
								flag = true
						end
						assert(flag, "dut在租约时间的一半时间内未发request报文！")
						@thread.join if @thread.alive? #如果线程还未结束，就等待其结束在进入clearup代码段
				}

				operate("5、更改服务器的租约时间，重新操作步骤1~3；") {
						# 备注：续约时间为租约时间的一半。
				}

		end

		def clearup
				operate("1 恢复DHCP服务器默认租约") {
						@thread.join if !@thread.nil? && @thread.alive?
						@tc_dumpcap_server.init_routeros_obj(@ts_server_ip)
						@tc_dumpcap_server.routeros_send_cmd(@tc_dhcp_lease_default_set) #设置租约为24小时
						rs = @tc_dumpcap_server.dhcp_srv_pri(@tc_dhcp_pri)
						p "修改服务器DHCP-server的租约时间为:#{rs["lease-time"]}".to_gbk
				}
		end

}
