#
# description:
# author:wuhongliang
# date:2015-08-26 11:47:03
# modify:
#
testcase {
		attr = {"id" => "ZLBF_17.1.9", "level" => "P2", "auto" => "n"}

		def prepare
				DRb.start_service
				@tc_wan_drb         = DRbObject.new_with_uri(@ts_drb_server2)
				#动态生成服务端口
				@tc_vir_tcpsrv_port = rand_port(50000, 65534)
				@tc_pub_tcp_port    = 30001
				@tc_vir_udpsrv_port = rand_port(40000, 49999)
				@tc_pub_udp_port    = 20001
				@tc_wait_time       = 3
				@tc_wait_dmz_time   = 10
				@tc_reboot_time     = 120
				@tc_relogin_time    = 60
				@tc_net_time        = 50
				@tc_udp_data_time   = 180
		end

		def process

				operate("1、在AP上配置一条PPPoE内置拨号，自动获取IP地址和网关，启用虚拟服务器功能；") {
						@browser.span(:id => @ts_tag_netset).click
						@wan_iframe = @browser.iframe(src: @ts_tag_netset_src)
						assert(@wan_iframe.exists?, "打开外网设置失败")

						#设置为有线wan
						rs1=@wan_iframe.link(:id => @ts_tag_wired_mode_link).class_name
						unless rs1=~/#{@ts_tag_select_state}/
								@wan_iframe.span(:id => @ts_tag_wired_mode_span).click
						end

						#设置为pppoe
						pppoe_radio       = @wan_iframe.radio(id: @ts_tag_wired_pppoe)
						pppoe_radio_state = pppoe_radio.checked?
						unless pppoe_radio_state
								pppoe_radio.click
								@wan_iframe.button(:id, @ts_tag_sbm).click
								# Watir::Wait.until(@tc_wait_time, "等待网络重启提示出现".to_gbk) {
								# 		@wan_iframe.div(class_name: @ts_tag_net_reset, text: @ts_tag_net_reset_text).visible?
								# }
								# Watir::Wait.while(@tc_net_time, "正在重启网络配置".to_gbk) {
								# 		@wan_iframe.div(class_name: @ts_tag_net_reset, text: @ts_tag_net_reset_text).present? #直到弹出的重启提示窗口消失
								# }
								sleep @tc_net_time
						end

						if @browser.div(class_name: @ts_aui_state_focus).exists? || @browser.div(class_name: @ts_aui_state).exists?
								@browser.execute_script(@ts_close_div)
						end

						#查看Wan ip地址
						@browser.span(:id, @ts_tag_status).click
						sleep @tc_wait_time
						@browser.iframe(src: @tag_status_iframe_src).wait_until_present(@tc_wait_time)
						@status_iframe= @browser.iframe(src: @tag_status_iframe_src)
						wan_addr      = @status_iframe.b(:id => @ts_tag_wan_ip).parent.text
						wan_addr =~@ts_tag_ip_regxp
						@tc_pppoe_addr = Regexp.last_match(1)
						puts "WAN状态显示获取的IP地址为：#{@tc_pppoe_addr}".to_gbk
						if @browser.div(class_name: @ts_aui_state_focus).exists? || @browser.div(class_name: @ts_aui_state).exists?
								@browser.execute_script(@ts_close_div)
						end
				}

				operate("2、在AP上依次添加服务FTP(TCP端口为20，21)，HTTP(TCP端口为80)，TELNET(TCP端口为23)，TFTP(UDP端口为69)等,服务器IP地址设置为PC2的IP地址等规则,保存；") {
						@browser.link(id: @ts_tag_options).wait_until_present(@tc_wait_time)
						@browser.link(id: @ts_tag_options).click
						@advance_iframe = @browser.iframe(src: @ts_tag_advance_src)
						assert(@advance_iframe.exists?, "打开高级设置失败")

						#选择‘应用设置’
						application      = @advance_iframe.link(id: @ts_tag_application)
						application_name = application.class_name
						unless application_name == @ts_tag_select_state
								application.click
								sleep @tc_wait_time
						end
						ip_info   = netsh_if_ip_show(nicname: @ts_nicname, type: "addresses")
						@tc_pc_ip = ip_info[:ip][0]
						puts "Virtual Server IP #{@tc_pc_ip}"
						#选择“虚拟服务器”标签
						virtualsrv       = @advance_iframe.link(id: @ts_tag_virtualsrv)
						virtualsrv_state = virtualsrv.parent.class_name
						virtualsrv.click unless virtualsrv_state==@ts_tag_liclass
						sleep @tc_wait_time
						#打开虚拟服务器开关
						@advance_iframe.button(id: @ts_tag_virtualsrv_sw).click if @advance_iframe.button(id: @ts_tag_virtualsrv_sw, class_name: @ts_tag_virsw_off).exists?
						#添加一条单端口映射
						unless @advance_iframe.text_field(name: @ts_tag_virip1).exists?
								@advance_iframe.button(id: @ts_tag_addvir).click
						end
						@advance_iframe.text_field(name: @ts_tag_virip1).set(@tc_pc_ip)
						@advance_iframe.text_field(name: @ts_tag_virpub_port1).set(@tc_pub_tcp_port)
						@advance_iframe.text_field(name: @ts_tag_virpri_port1).set(@tc_vir_tcpsrv_port)
						#添加第二条单端口映射
						unless @advance_iframe.text_field(name: @ts_tag_virip2).exists?
								@advance_iframe.button(id: @ts_tag_addvir).click
						end
						@advance_iframe.text_field(name: @ts_tag_virip2).set(@tc_pc_ip)
						@advance_iframe.text_field(name: @ts_tag_virpub_port2).set(@tc_pub_udp_port)
						@advance_iframe.text_field(name: @ts_tag_virpri_port2).set(@tc_vir_udpsrv_port)
						@advance_iframe.button(id: @ts_tag_save_btn).click
						sleep @tc_wait_time
				}

				operate("3、PC1访问PC2上面的FTP、HTTP、TELNET/TFTP服务器；") {
						ip_info = @tc_wan_drb.netsh_if_ip_show(nicname: "lan", type: "addresses")
						ip_arr  =ip_info[:ip]
						flag    = ip_arr.any? { |ip| ip=~/#{@ts_wan_client_ip}/ }
						assert(flag, "未配置指定的ip地址#{@ts_wan_client_ip}")

						routes = @tc_wan_drb.cmd_route_print()
						p routes[:permanent]
						temp = routes[:permanent].keys.any? { |net|
								new_net = net.sub(/\d+$/, "")
								@tc_pppoe_addr=~/#{new_net}/
						}

						#如果路由不存在侧添加路由
						unless temp
								dst  = @tc_pppoe_addr.sub(/\d+$/, "0")
								mask = "255.255.255.0"
								gw   = @ts_pptp_server_ip #网关为pptp服务地址
								tc_wan_drb.cmd_route_add(dst, mask, gw)
						end

						#启动tcp_server
						tcp_multi_server(@tc_pc_ip, @tc_vir_tcpsrv_port)
						#启动udp server
						udp_server(@tc_pc_ip, @tc_vir_udpsrv_port)

						rs      = @tc_wan_drb.tcp_client(@tc_pppoe_addr, @tc_pub_tcp_port)
						tcp_msg = rs.tcp_message
						puts "=================Message from TCP server==============="
						puts tcp_msg
						assert_match(/#{@ts_conn_state}/, tcp_msg, "开启虚拟服务器后，tcp连接失败")
						#udp客户端口也动态生成
						rs2     = @tc_wan_drb.udp_client(@ts_wan_client_ip, rand_port, @tc_pppoe_addr, @tc_pub_udp_port)
						udp_msg = rs2.udp_message
						puts "=================Message from UDP server==============="
						puts udp_msg
						assert_match(/#{@ts_conn_state}/, udp_msg, "开启虚拟服务器后，UDP连接失败")
				}

				operate("4、关闭AP虚拟服务器开关，PC1访问PC2上面的FTP、HTTP、TELNET/TFTP服务器；") {
						if @advance_iframe.button(id: @ts_tag_virtualsrv_sw, class_name: @ts_tag_virsw_on).exists?
								#关闭虚拟服务器开关
								@advance_iframe.button(id: @ts_tag_virtualsrv_sw).click
								@advance_iframe.button(id: @ts_tag_save_btn).click
								sleep @tc_wait_time
						end

						rs      = @tc_wan_drb.tcp_client(@tc_pppoe_addr, @tc_pub_tcp_port)
						tcp_msg = rs.tcp_message
						puts "=================After close portmapping Message from TCP server==============="
						puts tcp_msg
						refute_match(/#{@ts_conn_state}/, tcp_msg, "关闭虚拟服务器后，tcp连接成功")
						#已经建立的udp连接在服务关闭后一定时间内仍能通信，但在一定义时间后就无法通信了
						puts "Waiting for UDP...."
						sleep @tc_udp_data_time
						#udp客户端口也动态生成
						rs2     = @tc_wan_drb.udp_client(@ts_wan_client_ip, rand_port, @tc_pppoe_addr, @tc_pub_udp_port)
						udp_msg = rs2.udp_message
						puts "=================After close portmapping Message from UDP server==============="
						puts udp_msg
						refute_match(/#{@ts_conn_state}/, udp_msg, "关闭虚拟服务器后，UDP连接成功 ")
				}

				operate("5、重启AP，PC1访问PC2上面的FTP、HTTP、TELNET/TFTP服务器。") {
						#关闭高级设置
						file_div         = @browser.div(class_name: @ts_tag_file_div)
						zindex_value     = file_div.style(@ts_tag_style_zindex)
						#找到背景根DIV
						background_zindex=(zindex_value.to_i-1).to_s
						background_div   = @browser.element(xpath: "//div[contains(@style,'#{background_zindex}')]")

						#隐藏共享目录页面根DIV
						@browser.execute_script("$(arguments[0]).hide();", file_div)
						#隐藏背景根DIV
						@browser.execute_script("$(arguments[0]).hide();", background_div)

						@browser.span(id: @ts_tag_reboot).click
						reboot_confirm = @browser.button(class_name: @ts_tag_reboot_confirm)
						assert reboot_confirm.exists?, "未提示重启路由器要确认!"
						reboot_confirm.click

						puts "Waitfing for system reboot...."
						sleep(@tc_reboot_time) #由于重启会断开连接所以这里必须使用sleep来等待，而不是用Watir::Wait来等待
						rs = @browser.text_field(:name, @ts_tag_usr).wait_until_present(@tc_relogin_time)
						assert rs, "重启路由器失败未跳转到登录页面!"
						#重新登录路由器
						rs = login_no_default_ip(@browser)
						assert(rs, "重新登录路由器失败!")

						#查看Wan ip地址
						@browser.span(:id, @ts_tag_status).click
						@browser.iframe(src: @tag_status_iframe_src).wait_until_present(@tc_wait_time)
						@status_iframe= @browser.iframe(src: @tag_status_iframe_src)
						wan_addr      = @status_iframe.b(:id => @ts_tag_wan_ip).parent.text
						wan_addr =~@ts_tag_ip_regxp
						@tc_pppoe_addr = Regexp.last_match(1)
						puts "重启后WAN状态显示获取的IP地址为：#{@tc_pppoe_addr}".to_gbk

						#重启路由器后如果PC 获取IP与原来不同则要重新启动tcp服务
						ip_info    = netsh_if_ip_show(nicname: @ts_nicname, type: "addresses")
						@tc_pc_ip2 = ip_info[:ip][0]
						puts "pc ip addr:#{@tc_pc_ip2}"
						unless (@tc_pc_ip2==@tc_pc_ip)
								puts "重启路由器后， 启动新Virtual Server IP #{@tc_pc_ip2}".encode("GBK")
								#启动tcp_server
								tcp_multi_server(@tc_pc_ip2, @tc_vir_tcpsrv_port)
								#启动udp server
								udp_server(@tc_pc_ip2, @tc_vir_udpsrv_port)
						end

						rs      = @tc_wan_drb.tcp_client(@tc_pppoe_addr, @tc_pub_tcp_port)
						tcp_msg = rs.tcp_message
						puts "=================After reboot, Message from TCP server==============="
						print tcp_msg
						refute_match(/#{@ts_conn_state}/, tcp_msg, "关闭虚拟服务器后，tcp连接成功")
						#关闭
						puts "Waiting for UDP...."
						# sleep @tc_udp_data_time
						#udp客户端口也动态生成
						rs2     = @tc_wan_drb.udp_client(@ts_wan_client_ip, rand_port, @tc_pppoe_addr, @tc_pub_udp_port)
						udp_msg = rs2.udp_message
						puts "=================After reboot,Message from UDP server==============="
						puts udp_msg
						refute_match(/#{@ts_conn_state}/, udp_msg, "关闭虚拟服务器后，UDP连接成功")
				}


		end

		def clearup
				operate("1 删除虚拟服务器配置") {
						if @browser.link(id: @ts_tag_options).exists?
								@browser.refresh
								@browser.link(id: @ts_tag_options).click
								sleep @tc_wait_time
								@advance_iframe = @browser.iframe(src: @ts_tag_advance_src)
						else
								login_recover(@browser, @ts_default_ip)
								@browser.link(id: @ts_tag_options).wait_until_present(@tc_wait_time)
								@browser.link(id: @ts_tag_options).click
								sleep @tc_wait_time
								@advance_iframe = @browser.iframe(src: @ts_tag_advance_src)
						end

						#选择‘应用设置’
						application      = @advance_iframe.link(id: @ts_tag_application)
						application_name = application.class_name
						unless application_name == @ts_tag_select_state
								application.click
								sleep @tc_wait_time
						end

						#选择“虚拟服务器”标签
						virtualsrv       = @advance_iframe.link(id: @ts_tag_virtualsrv)
						virtualsrv_state = virtualsrv.parent.class_name
						virtualsrv.click unless virtualsrv_state==@ts_tag_liclass
						sleep @tc_wait_time
						flag=false
						if @advance_iframe.button(id: @ts_tag_virtualsrv_sw, class_name: @ts_tag_virsw_on).exists?
								#关闭虚拟服务器开关
								@advance_iframe.button(id: @ts_tag_virtualsrv_sw).click
								flag=true
						end
						if @advance_iframe.text_field(name: @ts_tag_virip1).exists?
								#删除端口映射
								@advance_iframe.button(id: @ts_tag_delvir).click
								flag=true
						end
						if flag
								#保存
								@advance_iframe.button(id: @ts_tag_save_btn).click
								sleep @tc_wait_time
						end
				}

				operate("2 恢复为默认的接入方式，DHCP接入") {
						if @browser.div(class_name: @ts_aui_state).exists? || @browser.div(class_name: @ts_aui_state_focus).exists?
								@browser.execute_script(@ts_close_div)
						end
						unless @browser.span(:id => @ts_tag_netset).exists?
								login_recover(@browser, @ts_default_ip)
						end

						@browser.span(:id => @ts_tag_netset).click
						@wan_iframe = @browser.iframe
						#设置wan连接方式为网线连接
						#设置为有线wan
						rs1         =@wan_iframe.link(:id => @ts_tag_wired_mode_link).class_name
						flag        =false
						unless rs1=~/#{@ts_tag_select_state}/
								@wan_iframe.span(:id => @ts_tag_wired_mode_span).click
								flag=true
						end

						#查询是否为为dhcp模式
						dhcp_radio       = @wan_iframe.radio(id: @ts_tag_wired_dhcp)
						dhcp_radio_state = dhcp_radio.checked?

						#设置WIRE WAN为dhcp
						unless dhcp_radio_state
								dhcp_radio.click
								flag=true
						end

						if flag
								@wan_iframe.button(:id, @ts_tag_sbm).click
								sleep @tc_net_time
						end
				}
		end

}
