#
# description:
# author:wuhongliang
# date:2015-08-26 11:47:03
# modify:
#
testcase {
		attr = {"id" => "ZLBF_18.1.2", "level" => "P1", "auto" => "n"}

		def prepare
				DRb.start_service
				@tc_wan_drb         = DRbObject.new_with_uri(@ts_drb_server2)
				#动态生成服务端口
				@tc_dmz_tcpsrv_port = rand_port(50000, 65534)
				@tc_dmz_udpsrv_port = rand_port(40000, 49999)
				@tc_wait_time       = 3
				@tc_wait_dmz_time   = 10
				@tc_net_time        = 30
				@tc_reboot_time     = 180
				#dmz关闭后，已经传送过udp数据的端口需要等待几分钟才生效
				#但其它端口立即生效
				@tc_udp_data_time   = 180
		end

		def process

				operate("1、在AP上配置一条PPTP内置拨号，自动获取IP地址和网关，启用DMZ功能，设置DMZ目标IP为下挂PC2的IP地址；") {
						@browser.span(:id, @ts_tag_status).click
						@browser.iframe(src: @tag_status_iframe_src).wait_until_present(@tc_wait_time)
						@status_iframe=@browser.iframe(src: @tag_status_iframe_src)
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
								puts "Waitfing for system reboot...."
								sleep @tc_reboot_time #由于重启会断开连接所以这里必须使用sleep来等待，而不是用Watir::Wait来等待
								rs = @browser.text_field(:name, @ts_tag_usr).wait_until_present(@tc_relogin_time)
								assert rs, "恢复出厂设置后未跳转到路由器登录页面!"
								login_no_default_ip(@browser) #重新登录
						end
						@browser.link(id: @ts_tag_options).wait_until_present(@tc_wait_time)
						@browser.link(id: @ts_tag_options).click
						@advance_iframe = @browser.iframe(src: @ts_tag_advance_src)
						assert(@advance_iframe.exists?, "打开高级设置失败")

						network_class = @advance_iframe.link(:id, @ts_tag_op_network).class_name
						unless network_class =~ /#{@ts_tag_select_state}/
								@advance_iframe.link(:id, @ts_tag_op_network).click
								sleep @tc_wait_time
						end
						@advance_iframe.link(:id, @ts_tag_op_pptp).click
						sleep @tc_wait_time

						puts "PPTP Server:#{@ts_pptp_server_ip}"
						puts "PPTP User:#{@ts_pptp_usr}"
						puts "PPTP PassWD:#{@ts_pptp_pw}"
						@advance_iframe.text_field(:id, @ts_tag_pptp_server).set(@ts_pptp_server_ip)
						@advance_iframe.text_field(:id, @ts_tag_pptp_usr).set(@ts_pptp_usr)
						@advance_iframe.text_field(:id, @ts_tag_pptp_pw).set(@ts_pptp_pw)
						@advance_iframe.button(:id, @ts_tag_sbm).click
						sleep @tc_net_time #路由器网络可能还在重启，这里增加延迟
				}

				operate("2、在PC2上建立FTP服务器，tftp服务器；") {
						@browser.link(id: @ts_tag_options).wait_until_present(@tc_wait_time)
						@browser.link(id: @ts_tag_options).click
						@advance_iframe = @browser.iframe(src: @ts_tag_advance_src)
						assert(@advance_iframe.exists?, "打开高级设置失败")
						sleep @tc_wait_time
						#选择‘应用设置’
						application      = @advance_iframe.link(id: @ts_tag_application)
						application_name = application.class_name
						unless application_name == @ts_tag_select_state
								application.click
								sleep @tc_wait_time
						end
						ip_info     = netsh_if_ip_show(nicname: @ts_nicname, type: "addresses")
						@pc_ip_addr = ip_info[:ip][0]
						puts "DMZ Server IP #{@pc_ip_addr}"
						#选择“DMZ设置”标签
						dmz       = @advance_iframe.link(id: @ts_tag_dmz)
						dmz_state = dmz.parent.class_name
						dmz.click unless dmz_state==@ts_tag_liclass
						sleep @tc_wait_time
						#打开dmz开关
						@advance_iframe.button(id: @ts_tag_dmzsw).click if @advance_iframe.button(id: @ts_tag_dmzsw, class_name: @ts_tag_dmzsw_off).exists?
						#配置dmz 服务器ip
						@advance_iframe.text_field(id: @ts_tag_dmzip).set(@pc_ip_addr)
						@advance_iframe.button(id: @ts_tag_sbm).click
						sleep @tc_wait_time
				}

				operate("3、在PC1上开启TFTP、 FTP客户端访问AP的WAN口IP地址,并进行相应的业务下载或者上传，分别在PC2网卡上，Server上抓包观察；") {
						#查看Wan ip地址
						@browser.span(:id, @ts_tag_status).click
						@browser.iframe(src: @tag_status_iframe_src).wait_until_present(@tc_wait_time)
						@status_iframe= @browser.iframe(src: @tag_status_iframe_src)
						wan_addr      = @status_iframe.b(:id => @ts_tag_wan_ip).parent.text
						wan_addr =~@ts_tag_ip_regxp
						@tc_ppptp_addr = Regexp.last_match(1)
						puts "WAN状态显示获取的IP地址为：#{@tc_ppptp_addr}".to_gbk

						#lan访问wan
						http_get = HtmlTag::TestHttpClient.new(@ts_wan_pppoe_httpip).get
						puts "=================客户端获取到Http Server Message=================".encode("GBK")
						print http_get+"\n"
						assert_match(/#{@ts_conn_state}/, http_get, "开启dmz后，客户端1连接到WAN侧http服务失败")

						ip_info = @tc_wan_drb.netsh_if_ip_show(nicname: "lan", type: "addresses")
						ip_arr  =ip_info[:ip]
						flag    = ip_arr.any? { |ip| ip=~/#{@ts_wan_client_ip}/ }
						assert(flag, "未配置指定的ip地址#{@ts_wan_client_ip}")

						routes = @tc_wan_drb.cmd_route_print()
						p routes[:permanent]
						temp = routes[:permanent].keys.any? { |net|
								new_net = net.sub(/\d+$/, "")
								@tc_ppptp_addr=~/#{new_net}/
						}

						#如果路由不存在侧添加路由
						unless temp
								dst  = @tc_ppptp_addr.sub(/\d+$/, "0")
								mask = "255.255.255.0"
								gw   = @ts_pptp_server_ip
								@tc_wan_drb.cmd_route_add(dst, mask, gw)
						end

						#启动tcp_server
						@tc_tcp_srvthr = tcp_multi_server(@pc_ip_addr, @tc_dmz_tcpsrv_port)
						#启动udp server
						@tc_udp_srvthr = udp_server(@pc_ip_addr, @tc_dmz_udpsrv_port)
				}

				operate("4、在PC2上访问PC1的WEB服务是否成功；") {
						#wan访问lan dmz
						rs      = @tc_wan_drb.tcp_client(@tc_ppptp_addr, @tc_dmz_tcpsrv_port)
						tcp_msg = rs.tcp_message
						puts "=================Message from TCP server==============="
						puts tcp_msg
						assert_match(/#{@ts_conn_state}/, tcp_msg, "开启dmz后，tcp连接失败")
						#udp客户端口也动态生成
						rs2     = @tc_wan_drb.udp_client(@ts_wan_client_ip, rand_port, @tc_ppptp_addr, @tc_dmz_udpsrv_port, "PPTP")
						udp_msg = rs2.udp_message
						puts "=================Message from UDP server==============="
						puts udp_msg+"\n"
						assert_match(/#{@ts_conn_state}/, udp_msg, "开启dmz后，UDP连接失败")
				}

				operate("5、禁用DMZ，重复步骤3，4；") {
						@browser.link(id: @ts_tag_options).wait_until_present(@tc_wait_time)
						@browser.link(id: @ts_tag_options).click
						sleep(@tc_wait_dmz_time)
						@advance_iframe  = @browser.iframe(src: @ts_tag_advance_src)

						#选择‘应用设置’
						application      = @advance_iframe.link(id: @ts_tag_application)
						application_name = application.class_name
						unless application_name == @ts_tag_select_state
								application.click
								sleep @tc_wait_time
						end

						#选择“DMZ设置”标签
						dmz       = @advance_iframe.link(id: @ts_tag_dmz)
						dmz_state = dmz.parent.class_name
						dmz.click unless dmz_state==@ts_tag_liclass
						sleep @tc_wait_time
						#关闭dmz开关
						@advance_iframe.button(id: @ts_tag_dmzsw).click if @advance_iframe.button(id: @ts_tag_dmzsw, class_name: @ts_tag_dmzsw_on).exists?
						@advance_iframe.button(id: @ts_tag_sbm).click
						sleep @tc_wait_time

						rs      = @tc_wan_drb.tcp_client(@tc_ppptp_addr, @tc_dmz_tcpsrv_port)
						tcp_msg = rs.tcp_message
						puts "=================After closed DMZ,Message from TCP server==============="
						puts "no message: #{tcp_msg}"
						refute_match(/#{@ts_conn_state}/, tcp_msg, "关闭dmz后，tcp仍能连接")

						#udp客户端口也动态生成rand_port
						sleep @tc_udp_data_time
						rs2     = @tc_wan_drb.udp_client(@ts_wan_client_ip, rand_port, @tc_ppptp_addr, @tc_dmz_udpsrv_port)
						udp_msg = rs2.udp_message
						puts "=================After closed DMZ,Message from UDP server==============="
						puts "no message: #{udp_msg}"
						refute_match(/#{@ts_conn_state}/, udp_msg, "关闭dmz后，UDP仍能连接")
				}

				operate("6、反复禁用启用DMZ 3次以上，AP工作是否正常；") {
						2.times.each do |i|
								puts "Repeat open and close DMZ #{i} time"
								#打开dmz开关
								@advance_iframe.button(id: @ts_tag_dmzsw).click if @advance_iframe.button(id: @ts_tag_dmzsw, class_name: @ts_tag_dmzsw_off).exists?
								@advance_iframe.text_field(id: @ts_tag_dmzip).set(@pc_ip_addr)
								@advance_iframe.button(id: @ts_tag_sbm).click
								sleep @tc_wait_time
								#关闭DMZ
								@advance_iframe.button(id: @ts_tag_dmzsw).click if @advance_iframe.button(id: @ts_tag_dmzsw, class_name: @ts_tag_dmzsw_on).exists?
								@advance_iframe.button(id: @ts_tag_sbm).click
								sleep @tc_wait_time
						end
						rs=ping(@ts_web)
						assert(rs, "路由器无法访问外网")
				}


		end

		def clearup

				operate("1 关闭DMZ服务器上的服务") {
						@tc_tcp_srvthr.kill if !@tc_tcp_srvthr.nil? && @tc_tcp_srvthr.alive?
						@tc_udp_srvthr.kill if !@tc_udp_srvthr.nil? && @tc_udp_srvthr.alive?
				}
				operate("2 取消DMZ") {
						if @browser.div(class_name: @ts_aui_state).exists? || @browser.div(class_name: @ts_aui_state_focus).exists?
								@browser.execute_script(@ts_close_div)
						end

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

						#选择“DMZ设置”标签
						dmz       = @advance_iframe.link(id: @ts_tag_dmz)
						dmz_state = dmz.parent.class_name
						dmz.click unless dmz_state==@ts_tag_liclass
						sleep @tc_wait_time

						if @advance_iframe.button(id: @ts_tag_dmzsw, class_name: @ts_tag_dmzsw_on).exists?
								#关闭dmz开关
								@advance_iframe.button(id: @ts_tag_dmzsw).click
								#提交
								@advance_iframe.button(id: @ts_tag_sbm).click
								sleep @tc_wait_time
						end
				}

				operate("3 恢复为默认的接入方式，DHCP接入") {
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
