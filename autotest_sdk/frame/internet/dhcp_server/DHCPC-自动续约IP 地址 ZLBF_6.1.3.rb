#
# description:
# 续约时间为租约时间的一半
# author:liluping
# date:2015-11-05 14:00:18
# modify:
#
testcase {
		attr = {"id" => "ZLBF_6.1.3", "level" => "P2", "auto" => "n"}

		def prepare
				@tc_dumpcap_server         = DRbObject.new_with_uri(@ts_drb_server2)
				@tc_wait_time              = 3
				@tc_net_time               = 60
				@tc_lan_time               = 15
				@tc_lease_time             = "120"
				@tc_dhcp_server_ip         = "10.10.10.1"
				@tc_dhcp_lease_set         = "ip dhcp-server set lease-time=00:01:00 numbers=DHCP-server" #修改租约为1分钟
				@tc_dhcp_lease_default_set = "ip dhcp-server set lease-time=1d numbers=DHCP-server" #默认为一天
				@tc_dhcp_pri               = "ip dhcp-server pri"
		end

		def process

				operate("0、修改服务器租约时间；") {
						@tc_dumpcap_server.init_routeros_obj(@ts_server_ip)
						@tc_dumpcap_server.routeros_send_cmd(@tc_dhcp_lease_set) #设置租约为1分钟
						rs = @tc_dumpcap_server.dhcp_srv_pri(@tc_dhcp_pri)
						p "修改服务器DHCP-server的租约时间为:#{rs["lease-time"]}".to_gbk
				}

				operate("1、DUT上配置相应的DHCPC 方式接入配置，查看DUT是否可以获取到DHCP Server配置的相关地址信息等；") {
						@mac = @browser.span(id: @ts_tag_systemver).parent.text.slice(/MAC\s*:\s*(.+)/, 1)
						p "获取mac地址为：#{@mac}".to_gbk
						@browser.span(:id => @ts_tag_netset).click
						@wan_iframe = @browser.iframe(src: @ts_tag_netset_src)
						flag        = false
						#设置wan连接方式为网线连接
						rs1         = @wan_iframe.link(:id => @ts_tag_wired_mode_link)
						rs1.wait_until_present(@tc_wait_time)
						unless rs1.class_name =~/ #{@ts_tag_select_state}/
								@wan_iframe.span(:id => @ts_tag_wired_mode_span).click
								flag = true
						end
						#查询是否为为dhcp模式
						dhcp_radio       = @wan_iframe.radio(id: @ts_tag_wired_dhcp)
						dhcp_radio_state = dhcp_radio.checked?
						#设置WIRE WAN为DHCP模式
						unless dhcp_radio_state
								dhcp_radio.click
								flag = true
						end
						if flag
								@wan_iframe.button(:id, @ts_tag_sbm).click
								puts "Waiting for net reset..."
								sleep @tc_net_time
						end
						p "验证dut是否获取到DHCP Server配置的相关地址信息".to_gbk
						if @browser.div(class_name: @ts_aui_state).exists?||@browser.div(class_name: @ts_aui_state_focus).exists?
								@browser.execute_script(@ts_close_div)
						end
						@browser.span(:id => @ts_tag_status).wait_until_present(@tc_wait_time)
						@browser.span(:id => @ts_tag_status).click
						@status_iframe = @browser.iframe(src: @ts_tag_status_iframe_src)
						@status_iframe.b(:id => @ts_tag_wan_ip).wait_until_present(@tc_wait_time)
						wan_addr     = @status_iframe.b(:id => @ts_tag_wan_ip).parent.text.to_gbk
						wan_type     = @status_iframe.b(:id => @ts_tag_wan_type).parent.text
						mask         = @status_iframe.b(:id => @ts_tag_wan_mask).parent.text.to_gbk
						gateway_addr = @status_iframe.b(:id => @ts_tag_wan_gw).parent.text
						dns_addr     = @status_iframe.b(:id => @ts_tag_wan_dns).parent.text
						assert_match(@ip_regxp, wan_addr, 'DHCP获取ip地址失败！')
						assert_match(/#{@ts_wan_mode_dhcp}/, wan_type, '接入类型错误！')
						assert_match(@ip_regxp, mask, 'DHCP获取ip地址掩码失败！')
						assert_match(@ip_regxp, gateway_addr, 'DHCP获取网关ip地址失败！')
						assert_match(@ip_regxp, dns_addr, 'DHCP获取dns ip地址失败！')
				}

				operate("2、在LAN PC上执行ping dhcp server IP-t；") {
						@thread = Thread.new do
								rs = ping_lost_pack(@tc_dhcp_server_ip, 150)
								# assert(rs, "PC上ping dhcp server IP 不通")
								assert(rs<1, "pc在ping过程中有丢包现象")
								p "ping执行结束，无丢包现象！".to_gbk
						end

				}

				operate("3、等待3分钟后，查看DUT是否发request报文，请求续约IP地址，续约间隔是否正常，PC PING是否有丢包现像；") {
						p "查看DUT是否发request报文".to_gbk
						tc_cap_fields = "-e frame.time_relative" #查看发送报文时所用的时间
						tc_cap_filter = "bootp.type==1&&eth.src==#{@mac}" #约束条件为: request报文并且进行mac地址约束
						args          = {nic: @ts_server_lannic, filter: tc_cap_filter, duration: @tc_lease_time, fields: tc_cap_fields}
						ts            = @tc_dumpcap_server.tshark_display_filter_fields(args).last(2)
						p "capture package: #{ts}".to_gbk
						assert(!ts.empty?, "未抓取到包！")
						request_time2 = ts[1].slice(/->(.+)/, 1).to_i
						request_time1 = ts[0].slice(/->(.+)/, 1).to_i
						puts "两次request报文时间点分别是：#{request_time1}s,和 #{request_time2}s".to_gbk
						flag  = false
						value =request_time2-request_time1
						puts "DHCP服务器租期为60s时，路由器WAN发送request的间隔为#{value}"
						if (value>= 30 && value <= 31)
								flag = true
						end
						assert(flag, "dut在租约时间的一半时间内未发request报文！")
						@thread.join if @thread.alive? #如果线程还未结束，就等待其结束在进入clearup代码段
				}

				# operate("4、更改服务器的租约时间，重新操作步骤1~3；") {
				#
				# }

		end

		def clearup
				operate("1 恢复DHCP服务器默认租约") {
						@tc_dumpcap_server.init_routeros_obj(@ts_server_ip)
						@tc_dumpcap_server.routeros_send_cmd(@tc_dhcp_lease_default_set) #设置租约为1分钟
						rs = @tc_dumpcap_server.dhcp_srv_pri(@tc_dhcp_pri)
						p "修改服务器DHCP-server的租约时间为:#{rs["lease-time"]}".to_gbk
				}
		end

}
