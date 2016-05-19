#
# description:
# author:wuhongliang
# date:2015-08-26 11:47:03
# modify:
#
testcase {
		attr = {"id" => "ZLBF_17.1.1", "level" => "P1", "auto" => "n"}

		def prepare
				DRb.start_service
				@tc_wan_drb         = DRbObject.new_with_uri(@ts_drb_server2)
				#动态生成服务端口
				@tc_vir_tcpsrv_port = rand_port(50000, 65534)
				@tc_pub_tcp_port    = 30000
				@tc_vir_udpsrv_port = rand_port(40000, 49999)
				@tc_pub_udp_port    = 20000
				@tc_wait_time       = 3
				@tc_status_time     = 10
				@tc_net_time        = 50
				@tc_reboot_time     = 120
				@tc_relogin_time    = 80
		end

		def process

				operate("1、在AP上配置一条PPPoE内置拨号，自动获取IP地址和网关，启用虚拟服务器功能；") {
						@browser.span(:id, @ts_tag_status).click
						@browser.iframe(src: @ts_tag_status_iframe_src).wait_until_present(@tc_wait_time)
						@status_iframe=@browser.iframe(src: @ts_tag_status_iframe_src)
						lan_ip        = @status_iframe.b(id: @ts_tag_lan_ip).parent.text
						#如果路由器不是默认lanip先恢复为默认ip
						unless lan_ip =~/#{@ts_default_ip}/
								if @browser.div(class_name: @ts_aui_state_focus).exists? || @browser.div(class_name: @ts_aui_state).exists?
										@browser.execute_script(@ts_close_div)
								end
								@browser.link(id: @ts_tag_options).wait_until_present(@tc_wait_time)
								@browser.link(id: @ts_tag_options).click
								@advance_iframe = @browser.iframe(src: @ts_tag_advance_src)
								assert(@advance_iframe.exists?, "打开高级设置失败!")

								#选择‘系统设置’
								sysset      = @advance_iframe.link(id: @ts_tag_op_system)
								sysset_name = sysset.class_name
								unless sysset_name == @ts_tag_select_state
										sysset.click
										sleep @tc_wait_time
								end

								#选择“恢复出厂设置”标签
								system_reset       = @advance_iframe.link(id: @ts_tag_recover)
								system_reset_state = system_reset.parent.class_name
								system_reset.click unless system_reset_state==@ts_tag_liclass
								sleep @tc_wait_time
								#点击”恢复出厂设置“按钮
								@advance_iframe.button(id: @ts_tag_reset_factory).click
								sleep @tc_wait_time
								reset_confirm_tip = @advance_iframe.div(class_name: @ts_tag_reset, text: @ts_tag_reset_text)
								assert reset_confirm_tip.visible?, "未弹出恢复出厂提示!"
								#确认恢复出厂值
								reset_confirm = @advance_iframe.button(class_name: @ts_tag_reboot_confirm)
								reset_confirm.click
								Watir::Wait.until(@tc_wait_time, "开始恢复出厂设置") {
										@advance_iframe.div(class_name: @ts_tag_reset, text: @ts_tag_reseting_text)
								}
								puts "Waitfing for system reboot...."
								sleep @tc_reboot_time #由于重启会断开连接所以这里必须使用sleep来等待，而不是用Watir::Wait来等待
								rs = @browser.text_field(:name, @ts_tag_usr).wait_until_present(@tc_relogin_time)
								assert rs, "恢复出厂设置后未跳转到路由器登录页面!"
								login_no_default_ip(@browser) #重新登录
						end

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
								puts "设置PPPOE帐户名：#{@ts_pppoe_usr}和PPPOE密码:#{@ts_pppoe_pw}！".to_gbk
								@wan_iframe.text_field(id: @ts_tag_pppoe_usr).set(@ts_pppoe_usr)
								@wan_iframe.text_field(id: @ts_tag_pppoe_pw).set(@ts_pppoe_pw)
								@wan_iframe.button(id: @ts_tag_sbm).click
								sleep @tc_net_time
						end
						if @browser.div(class_name: @ts_aui_state_focus).exists? || @browser.div(class_name: @ts_aui_state).exists?
								@browser.execute_script(@ts_close_div)
						end
						#查看Wan ip地址
						@browser.span(:id, @ts_tag_status).click
						sleep @tc_status_time
						@browser.iframe(src: @ts_tag_status_iframe_src).wait_until_present(@tc_wait_time)
						@status_iframe= @browser.iframe(src: @ts_tag_status_iframe_src)
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
						ip_info     = netsh_if_ip_show(nicname: @ts_nicname, type: "addresses")
						@pc_ip_addr = ip_info[:ip][0]
						puts "Virtual Server IP #{@pc_ip_addr}"
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
						@advance_iframe.text_field(name: @ts_tag_virip1).set(@pc_ip_addr)
						@advance_iframe.text_field(name: @ts_tag_virpub_port1).set(@tc_pub_tcp_port)
						@advance_iframe.text_field(name: @ts_tag_virpri_port1).set(@tc_vir_tcpsrv_port)
						#添加第二条单端口映射
						unless @advance_iframe.text_field(name: @ts_tag_virip2).exists?
								@advance_iframe.button(id: @ts_tag_addvir).click
						end
						@advance_iframe.text_field(name: @ts_tag_virip2).set(@pc_ip_addr)
						@advance_iframe.text_field(name: @ts_tag_virpub_port2).set(@tc_pub_udp_port)
						@advance_iframe.text_field(name: @ts_tag_virpri_port2).set(@tc_vir_udpsrv_port)
						@advance_iframe.button(id: @ts_tag_save_btn).click
						sleep @tc_wait_time
				}

				operate("3、在PC2上开启HTTP、 FTP、TELNET、TFTP等服务，在PC1上开启HTTP服务；") {
						ip_info = @tc_wan_drb.netsh_if_ip_show(nicname: "lan", type: "addresses")
						ip_arr  =ip_info[:ip]
						flag    = ip_arr.any? { |ip| ip=~/#{@ts_wan_client_ip}/ }
						assert(flag, "未配置指定的ip地址#{@ts_wan_client_ip}")

						#查询服务器上默认路由是否存在
						routes = @tc_wan_drb.cmd_route_print()
						puts "WAN SERVER Permannet Route Info"
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
								cmd_route_add(dst, mask, gw)
						end

						#启动tcp_server
						tcp_multi_server(@pc_ip_addr, @tc_vir_tcpsrv_port)
						#启动udp server
						udp_server(@pc_ip_addr, @tc_vir_udpsrv_port)
				}

				operate("4、PC1通过WAN口访问PC2上的HTTP、 FTP、TELNET、TFTP等服务，并在PC2网卡上，Server上抓包观察；") {
						rs      = @tc_wan_drb.tcp_client(@tc_pppoe_addr, @tc_pub_tcp_port)
						tcp_msg = rs.tcp_message
						puts "=================Message from TCP server==============="
						print tcp_msg
						assert_match(/#{@ts_conn_state}/, tcp_msg, "开启虚拟服务器后，tcp连接失败")
						#udp客户端口也动态生成
						rs2     = @tc_wan_drb.udp_client(@ts_wan_client_ip, rand_port, @tc_pppoe_addr, @tc_pub_udp_port)
						udp_msg = rs2.udp_message
						puts "=================Message from UDP server==============="
						print udp_msg+"\n"
						assert_match(/#{@ts_conn_state}/, udp_msg, "开启虚拟服务器后，UDP连接失败")
				}

				operate("5、在PC2上访问PC1的HTTP服务是否成功，并在PC1上抓包观察；") {
						http_get = HtmlTag::TestHttpClient.new(@ts_wan_pppoe_httpip).get
						puts "=========================客户端获取到Http Server Message========================".encode("GBK")
						print http_get+"\n"
						assert_match(/#{@ts_conn_state}/, http_get, "开启虚拟服务器后，客户端1连接到WAN侧http服务失败")
				}


		end

		def clearup

				operate("1 删除虚拟服务器配置") {
						if !@advance_iframe.nil? && !@advance_iframe.exists?
								@browser.link(id: @ts_tag_options).wait_until_present(@tc_wait_time)
								@browser.link(id: @ts_tag_options).click
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
