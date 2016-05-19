#
# description:
# author:wuhongliang
# date:2015-08-26 11:47:03
# modify:
#
testcase {
		attr = {"id" => "ZLBF_18.1.1", "level" => "P1", "auto" => "n"}

		def prepare
				DRb.start_service
				@tc_client_drb      = DRbObject.new_with_uri(@ts_drb_server)
				@tc_wan_drb         = DRbObject.new_with_uri(@ts_drb_server2)
				#动态生成服务端口
				@tc_dmz_tcpsrv_port = rand_port(50000, 65534)
				@tc_dmz_udpsrv_port = rand_port(40000, 49999)
				@tc_wait_time       = 3
				@tc_net_time        = 30
				@tc_reboot_time     = 120
				@tc_relogin_time    = 80
		end

		def process
				operate("1、在AP上配置一条PPPoE内置拨号，自动获取IP地址和网关，启用DMZ功能，设置DMZ目标IP为下挂PC2的IP地址；") {
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
								#选择PPPOE拨号
								pppoe_radio.click
								puts "设置PPPOE帐户名和PPPOE密码！".to_gbk
								@wan_iframe.text_field(id: @ts_tag_pppoe_usr).set(@ts_pppoe_usr)
								@wan_iframe.text_field(id: @ts_tag_pppoe_pw).set(@ts_pppoe_pw)
								@wan_iframe.button(:id, @ts_tag_sbm).click
								Watir::Wait.until(@tc_wait_time, "等待网络重启提示出现".to_gbk) {
										@wan_iframe.div(class_name: @ts_tag_net_reset, text: @ts_tag_net_reset_text).visible?
								}
								Watir::Wait.while(@tc_net_time, "正在重启网络配置".to_gbk) {
										@wan_iframe.div(class_name: @ts_tag_net_reset, text: @ts_tag_net_reset_text).present? #直到弹出的重启提示窗口消失
								}
						end
						if @browser.div(class_name: @ts_aui_state_focus).exists? || @browser.div(class_name: @ts_aui_state).exists?
								@browser.execute_script(@ts_close_div)
						end
				}

				operate("2、在PC2上建立FTP服务器，tftp服务器；") {
						@browser.link(id: @ts_tag_options).wait_until_present(@tc_wait_time)
						@browser.link(id: @ts_tag_options).click
						@advance_iframe = @browser.iframe(src: @ts_tag_advance_src)
						assert(@advance_iframe.exists?, "打开高级设置失败")
						#选择‘应用设置’
						sleep @tc_wait_time
						@advance_iframe.link(id: @ts_tag_application).wait_until_present(@tc_wait_time)
						application      = @advance_iframe.link(id: @ts_tag_application)
						application_name = application.class_name
						unless application_name == @ts_tag_select_state
								application.click
								sleep @tc_wait_time
						end
						ip_info     = netsh_if_ip_show(nicname: @ts_nicname, type: "addresses")
						@pc_ip_addr = ip_info[:ip][0]
						#将PC设置为静态地址，防止后面的重启导致ip地址变化
						# gw          = ip_info[:gateway][0]
						# args        ={nicname: @ts_nicname, source: "static", ip: @pc_ip_addr, mask: "255.255.255.0", gateway: gw}
						# netsh_if_ip_setip(args)
						puts "DMZ Server IP #{@pc_ip_addr}"
						#选择“DMZ设置”标签
						dmz       = @advance_iframe.link(id: @ts_tag_dmz)
						dmz_state = dmz.parent.class_name
						dmz.click unless dmz_state==@ts_tag_liclass
						sleep @tc_wait_time
						#打开dmz开关
						@advance_iframe.button(id: @ts_tag_dmzsw).click if @advance_iframe.button(id: @ts_tag_dmzsw, class_name: @ts_tag_dmzsw_off).exists?
						@advance_iframe.text_field(id: @ts_tag_dmzip).set(@pc_ip_addr)
						@advance_iframe.button(id: @ts_tag_sbm).click
						sleep @tc_wait_time
				}

				operate("3、在PC1上开启TFTP、 FTP客户端访问AP的WAN口IP地址,并进行相应的业务下载或者上传，分别在PC2网卡上，Server上抓包观察；") {
						#查看Wan ip地址
						@browser.span(:id, @ts_tag_status).click
						@browser.iframe(src: @tag_status_iframe_src).wait_until_present(@tc_wait_time)
						@status_iframe= @browser.iframe(src: @tag_status_iframe_src)
						p wan_addr = @status_iframe.b(:id => @ts_tag_wan_ip).parent.text
						wan_addr =~@ts_tag_ip_regxp
						@tc_pppoe_addr = Regexp.last_match(1)
						puts "WAN状态显示获取的IP地址为：#{@tc_pppoe_addr}".to_gbk
						refute_nil(@tc_pppoe_addr, "未获取ip地址")
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
								cmd_route_add(dst, mask, gw)
						end

						#启动tcp_server
						@tc_tcp_thr = tcp_multi_server(@pc_ip_addr, @tc_dmz_tcpsrv_port)
						#启动udp server
						@tc_udp_thr = udp_server(@pc_ip_addr, @tc_dmz_udpsrv_port)

						rs      = @tc_wan_drb.tcp_client(@tc_pppoe_addr, @tc_dmz_tcpsrv_port)
						tcp_msg = rs.tcp_message
						puts "=================Message from TCP server==============="
						print tcp_msg
						assert_match(/#{@ts_conn_state}/, tcp_msg, "开启dmz后，tcp连接失败")
						#udp客户端口也动态生成
						rs2     = @tc_wan_drb.udp_client(@ts_wan_client_ip, rand_port, @tc_pppoe_addr, @tc_dmz_udpsrv_port)
						udp_msg = rs2.udp_message
						puts "=================Message from UDP server==============="
						print udp_msg+"\n"
						assert_match(/#{@ts_conn_state}/, udp_msg, "开启dmz后，UDP连接失败")
				}

				operate("4、在LAN侧PC3开启TFTP、 FTP客户端访问AP的WAN口IP地址,并进行相应的业务下载或者上传，分别在PC2网卡上，Server上抓包观察；") {
						if @browser.div(class_name: @ts_aui_state_focus).exists? || @browser.div(class_name: @ts_aui_state).exists?
								@browser.execute_script(@ts_close_div)
						end
						@browser.span(id: @ts_tag_lan).click
						@browser.iframe(src: @ts_tag_lan_src).wait_until_present(@tc_wait_time)
						@lan_iframe  = @browser.iframe(src: @ts_tag_lan_src)
						current_ssid = @lan_iframe.text_field(id: @ts_tag_ssid).value
						current_pw   = @lan_iframe.text_field(id: @ts_tag_input_pw).value
						rs           = @tc_client_drb.connect(current_ssid, @ts_wifi_flag, current_pw)
						assert rs, "WIFI连接失败"
						http_get = @tc_client_drb.http_client(@ts_wan_pppoe_httpip)
						puts "=================第二个客户端面获取到Message from HTTP server===============".encode("GBK")
						puts http_get
						assert_match(/#{@ts_conn_state}/, http_get, "开启dmz后，其它客户端连接到WAN侧http服务失败")
						if @browser.div(class_name: @ts_aui_state_focus).exists? || @browser.div(class_name: @ts_aui_state).exists?
								@browser.execute_script(@ts_close_div)
						end
				}

				operate("5、在PC2上访问PC1的WEB服务是否成功。") {
						http_get = HtmlTag::TestHttpClient.new(@ts_wan_pppoe_httpip).get
						puts "=========================第一个客户端获取到Http Server Message========================".encode("GBK")
						print http_get+"\n"
						assert_match(/#{@ts_conn_state}/, http_get, "开启dmz后，客户端1连接到WAN侧http服务失败")
				}

				operate("6、重启后，检测DMZ功能是否生效；") {
						@browser.span(id: @ts_tag_reboot).click
						reboot_confirm = @browser.button(class_name: @ts_tag_reboot_confirm)
						assert reboot_confirm.exists?, "未提示重启路由器要确认!"
						reboot_confirm.click

						#<div class="aui_content" style="padding: 20px 25px;">正在重启中，请稍等...</div>
						Watir::Wait.until(@tc_wait_time, "重启路由器正在重启提示未出现") {
								@browser.div(:class_name, @ts_tag_rebooting).visible?
						}
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

						rs      = @tc_wan_drb.tcp_client(@tc_pppoe_addr, @tc_dmz_tcpsrv_port)
						tcp_msg = rs.tcp_message
						puts "=================重起后Message from TCP server===============".encode("GBK")
						print tcp_msg
						assert_match(/#{@ts_conn_state}/, tcp_msg, "重启路由器后，tcp连接失败")

						rs2     = @tc_wan_drb.udp_client(@ts_wan_client_ip, rand_port, @tc_pppoe_addr, @tc_dmz_udpsrv_port)
						udp_msg = rs2.udp_message
						puts "=================重启后Message from UDP server===============".encode("GBK")
						print udp_msg+"\n"
						assert_match(/#{@ts_conn_state}/, udp_msg, "重启路由器后，UDP连接失败")

						http_get = HtmlTag::TestHttpClient.new(@ts_wan_pppoe_httpip).get
						puts "================重启后第一个客户端获取到Http Server Message==============".encode("GBK")
						print http_get+"\n"
						assert_match(/#{@ts_conn_state}/, http_get, "开启dmz后，客户端1连接到WAN侧http服务失败")
				}

				operate("7、从PC1 ping WAN口 IP.") {
						rs = @tc_wan_drb.ping(@tc_pppoe_addr)
						assert(rs, "从WAN侧PING路由器成功")
				}


		end

		def clearup
				operate("1 停止tcp udp server") {
						begin
								#停止tcp udp server
								@tc_tcp_thr.kill if !@tc_tcp_thr.nil?&&@tc_tcp_thr.alive?
								@tc_udp_thr.kill if !@tc_tcp_thr.nil?&&@tc_udp_thr.alive?
						rescue => ex
								p ex.message.to_s
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

				operate("2 取消DMZ") {
						if @browser.div(class_name: @ts_aui_state).exists? || @browser.div(class_name: @ts_aui_state_focus).exists?
								@browser.execute_script(@ts_close_div)
						end
						@browser.link(id: @ts_tag_options).wait_until_present(@tc_wait_time)
						@browser.link(id: @ts_tag_options).click
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

						if @advance_iframe.button(id: @ts_tag_dmzsw, class_name: @ts_tag_dmzsw_on).exists?
								#关闭dmz开关
								@advance_iframe.button(id: @ts_tag_dmzsw).click
								#提交
								@advance_iframe.button(id: @ts_tag_sbm).click
								sleep @tc_wait_time
						end
				}

		end

}
