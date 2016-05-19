#
# description:
# author:wuhongliang
# date:2015-11-05 14:00:19
# modify:
#
testcase {
		attr = {"id" => "ZLBF_17.1.6", "level" => "P3", "auto" => "n"}

		def prepare
				DRb.start_service
				@tc_wan_drb         = DRbObject.new_with_uri(@ts_drb_server2)
				@tc_vir_tcpsrv_port = 10000
				@tc_vir_udpsrv_port = 20000
				@tc_pub_tcp_port    = 10000
				@tc_pub_udp_port    = 20000
				@tc_wait_time       = 3
				@tc_net_time        = 50
				@tc_reboot_time     = 120
				@tc_relogin_time    = 80
				@tc_tcp             = "TCP"
				@tc_udp             = "UDP"
		end

		def process

				operate("1、AP的接入类型选择为DHCP，保存配置；") {
						@browser.span(:id => @ts_tag_netset).click
						@wan_iframe = @browser.iframe(src: @ts_tag_netset_src)
						assert(@wan_iframe.exists?, '打开外网设置失败！')

						rs1=@wan_iframe.link(:id => @ts_tag_wired_mode_link).class_name
						unless rs1=~/#{@ts_tag_select_state}/
								@wan_iframe.span(:id => @ts_tag_wired_mode_span).click
						end

						dhcp_radio       = @wan_iframe.radio(id: @ts_tag_wired_dhcp)
						dhcp_radio_state = dhcp_radio.checked?
						unless dhcp_radio_state
								dhcp_radio.click
								@wan_iframe.button(:id, @ts_tag_sbm).click
								sleep @tc_net_time
						end

						if @browser.div(class_name: @ts_aui_state_focus).exists? || @browser.div(class_name: @ts_aui_state).exists?
								@browser.execute_script(@ts_close_div)
						end

						@browser.span(:id => @ts_tag_status).wait_until_present(@tc_wait_time)
						@browser.span(:id => @ts_tag_status).click
						@status_iframe = @browser.iframe(src: @ts_tag_status_iframe_src)
						assert(@status_iframe.exists?, '打开WAN状态失败！')
						wan_addr = @status_iframe.b(:id => @tag_wan_ip).parent.text
						wan_type = @status_iframe.b(:id => @tag_wan_type).parent.text
						@ts_tag_ip_regxp=~wan_addr
						@tc_dhcp_ip = Regexp.last_match(1)
						puts "WAN DHCPC IP ADDR #{@tc_dhcp_ip}"
						assert_match(@ts_tag_ip_regxp, wan_addr, 'dhcp获取ip地址失败！')
						assert_match(/#{@ts_wan_mode_dhcp}/, wan_type, '接入类型错误！')
				}

				operate("2、添加一条虚拟服务器规则,协议选择TCP,起始端口设置为10000，终止端口设置为10000，服务IP地址设置为PC2地址，保存；") {
						#打开高级设置
						option = @browser.link(:id => @ts_tag_options)
						option.click
						@advance_iframe  = @browser.iframe(src: @ts_tag_advance_src)
						#选择‘应用设置’
						application      = @advance_iframe.link(id: @ts_tag_application)
						application_name = application.class_name
						unless application_name == @ts_tag_select_state
								application.click
								sleep @tc_wait_time
						end
						#查询PC IP地址
						ip_info   = netsh_if_ip_show(nicname: @ts_nicname, type: "addresses")
						@tc_pc_ip = ip_info[:ip][0]
						puts "pc ip addr:#{@tc_pc_ip}"
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
						#设置虚拟服务器
						@advance_iframe.text_field(name: @ts_tag_virip1).set(@tc_pc_ip)
						@advance_iframe.text_field(name: @ts_tag_virpub_port1).set(@tc_pub_tcp_port)
						@advance_iframe.text_field(name: @ts_tag_virpri_port1).set(@tc_vir_tcpsrv_port)
						#选择TCP协议
						pro_select = @advance_iframe.select_list(name: @ts_tag_vir_protocol)
						pro_select.select(@tc_tcp)
						@advance_iframe.button(id: @ts_tag_save_btn).click
						sleep @tc_wait_time

						#查看服务器配置的网卡信息是否正确
						ip_info = @tc_wan_drb.netsh_if_ip_show(nicname: "lan", type: "addresses")
						ip_arr  = ip_info[:ip]
						flag    = ip_arr.any? { |ip| ip=~/#{@ts_wan_client_ip}/ }
						assert(flag, "未配置指定的ip地址#{@ts_wan_client_ip}")

						# 启动tcp_server
						tcp_multi_server(@tc_pc_ip, @tc_vir_tcpsrv_port)
						#启动udp server
						udp_server(@tc_pc_ip, @tc_vir_udpsrv_port)
				}

				operate("3、在PC1上打开IPTEST工具，网络模式选择“客户端模式”，网络类型选择“TCP”，远程端口号设置为10000，远程IP地址设置为“AP WAN口IP地址”，点击“开始连接”，分别在PC1，PC2网卡上抓包观察；") {
						#使用ruby socket来实现
						#TCP连接访问虚拟服务器
						rs1     = @tc_wan_drb.tcp_client(@tc_dhcp_ip, @tc_pub_tcp_port)
						tcp_msg = rs1.tcp_message
						puts "=================Message from TCP server==============="
						print tcp_msg
						assert_match(/#{@ts_conn_state}/, tcp_msg, "开启TCP虚拟服务器后，tcp连接失败")
						#udp 连接会失败，因为只开发TCP协议
						rs2     = @tc_wan_drb.udp_client(@ts_wan_client_ip, rand_port, @tc_dhcp_ip, @tc_pub_tcp_port)
						udp_msg = rs2.udp_message
						puts "=================Message from UDP server==============="
						print udp_msg+"\n"
						refute_match(/#{@ts_conn_state}/, udp_msg, "开启TCP虚拟服务器后，UDP连接成功")
				}

				operate("4、选择步骤2中添加的规则，更改协议为UDP,起始端口设置为20000，终止端口设置为20000，服务IP地址设置为PC2地址，是否能对已选择的规则进行修改，保存；") {
						#修改规则
						@advance_iframe.text_field(name: @ts_tag_virip1).set(@tc_pc_ip)
						@advance_iframe.text_field(name: @ts_tag_virpub_port1).set(@tc_pub_udp_port)
						@advance_iframe.text_field(name: @ts_tag_virpri_port1).set(@tc_vir_udpsrv_port)
						#选择UDP协议
						pro_select = @advance_iframe.select_list(name: @ts_tag_vir_protocol)
						pro_select.select(@tc_udp)
						@advance_iframe.button(id: @ts_tag_save_btn).click
						sleep @tc_wait_time+5 #修改后的规则要生效需要多等几秒
				}

				operate("5、在PC1上打开IPTEST工具，网络模式选择“客户端模式”，网络类型选择“UDP”，远程端口号设置为20000，远程IP地址设置为“AP WAN口IP地址”，点击“开始连接”,输入要发送的内容，点击“发送”，分别在PC1，PC2网卡上抓包观察；") {
						#使用ruby socket来实现
						# #TCP连接访问虚拟服务器会失败,因为只开启了UDP协议
						rs1     = @tc_wan_drb.tcp_client(@tc_dhcp_ip, @tc_pub_udp_port)
						tcp_msg = rs1.tcp_message
						puts "=================Message from TCP server==============="
						print tcp_msg
						print "\n"
						refute_match(/#{@ts_conn_state}/, tcp_msg, "开启UDP虚拟服务器后，TCP连接成功")
						#udp 连接成功，
						rs2     = @tc_wan_drb.udp_client(@ts_wan_client_ip, rand_port, @tc_dhcp_ip, @tc_pub_udp_port)
						udp_msg = rs2.udp_message
						puts "=================Message from UDP server==============="
						print udp_msg+"\n"
						assert_match(/#{@ts_conn_state}/, udp_msg, "开启UDP虚拟服务器后，UDP连接失败")
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
		end

}
