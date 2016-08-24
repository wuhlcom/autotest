#
# description:
# 使用静态IP接入来测试不使用PPTP接入来测试
# author:wuhongliang
# date:2015-11-05 14:00:19
# modify:
#
testcase {
		attr = {"id" => "ZLBF_17.1.5", "level" => "P2", "auto" => "n"}

		def prepare
				DRb.start_service
				@tc_wan_drb         = DRbObject.new_with_uri(@ts_drb_server2)
				@tc_vir_tcpsrv_port = 33000
				@tc_vir_udpsrv_port = 34000
				@tc_pub_tcp_port    = 23000
				@tc_pub_udp_port    = 24000
				@tc_wait_time       = 3
				@tc_net_time        = 60
				@tc_reboot_time     = 120
				@tc_relogin_time    = 80
		end

		def process

				operate("1、在AP上配置静态IP接入，启用虚拟服务器功能，新添加一条规则,协议选择TCP/UDP,起始与终止端口设置为5000，服务IP地址设置为PC2地址，保存；") {
						@browser.span(:id => @ts_tag_netset).click
						@wan_iframe = @browser.iframe(src: @ts_tag_netset_src)
						assert(@wan_iframe.exists?, "打开外网设置失败")

						#设置有线模式
						rs1=@wan_iframe.link(:id => @ts_tag_wired_mode_link).class_name
						unless rs1 =~/#{@ts_tag_select_state}/
								@wan_iframe.span(:id => @ts_tag_wired_mode_span).click
						end
						#设置静态IP
						static_radio = @wan_iframe.radio(:id => @ts_tag_wired_static)
						static_radio.click
						sleep @tc_wait_time

						@wan_iframe.text_field(:id, @ts_tag_staticIp).set(@ts_staticIp)
						@wan_iframe.text_field(:id, @ts_tag_staticNetmask).set(@ts_staticNetmask)
						@wan_iframe.text_field(:id, @ts_tag_staticGateway).set(@ts_staticGateway)
						@wan_iframe.text_field(:id, @ts_tag_staticPriDns).set(@ts_staticPriDns)
						if @wan_iframe.text_field(:id, @ts_tag_backupDns).exists?
								@wan_iframe.text_field(:id, @ts_tag_backupDns).set(@ts_staticBackupDns)
						end
						@wan_iframe.button(:id, @ts_tag_sbm).click
						sleep @tc_net_time

						#关闭上一个页面
						if @browser.div(class_name: @ts_aui_state_focus).exists? || @browser.div(class_name: @ts_aui_state).exists?
								@browser.execute_script(@ts_close_div)
						end

						#查看Wan ip地址
						@browser.span(:id, @ts_tag_status).click
						@browser.iframe(src: @tag_status_iframe_src).wait_until_present(@tc_wait_time)
						@status_iframe= @browser.iframe(src: @tag_status_iframe_src)

						wan_addr = @status_iframe.b(:id => @ts_tag_wan_ip).parent.text
						wan_addr =~@ts_tag_ip_regxp
						@tc_static_ip = Regexp.last_match(1)
						puts "WAN状态显示获取的IP地址为：#{@tc_static_ip}".to_gbk

						wan_type = @status_iframe.b(:id => @ts_tag_wan_type).parent.text
						wan_type =~/(#{@ts_wan_mode_static})/
						puts "WAN状态显示接入类型为：#{Regexp.last_match(1)}".to_gbk

						assert_match /#{@ts_staticIp}/, wan_addr, '静态ip配置失败！'
						assert_match /#{@ts_wan_mode_static}/, wan_type, '接入类型错误！'

						if @browser.div(class_name: @ts_aui_state_focus).exists? || @browser.div(class_name: @ts_aui_state).exists?
								@browser.execute_script(@ts_close_div)
						end
				}

				operate("2、重复步骤1分别添加端口号为80，8080，137，139，1024，10000，65535规则；") {
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

						#启动服务器
						ip_info = @tc_wan_drb.netsh_if_ip_show(nicname: "lan", type: "addresses")
						ip_arr  = ip_info[:ip]
						flag    = ip_arr.any? { |ip| ip=~/#{@ts_wan_client_ip}/ }
						assert(flag, "未配置指定的ip地址#{@ts_wan_client_ip}")

						#启动tcp_server
						tcp_multi_server(@tc_pc_ip, @tc_vir_tcpsrv_port)
						#启动udp server
						udp_server(@tc_pc_ip, @tc_vir_udpsrv_port)

						#连接虚拟服务器
						rs      = @tc_wan_drb.tcp_client(@tc_static_ip, @tc_pub_tcp_port)
						tcp_msg = rs.tcp_message
						puts "=================Message from TCP server==============="
						print tcp_msg
						assert_match(/#{@ts_conn_state}/, tcp_msg, "开启虚拟服务器后，tcp连接失败")
						#udp客户端口也动态生成
						rs2     = @tc_wan_drb.udp_client(@ts_wan_client_ip, rand_port, @tc_static_ip, @tc_pub_udp_port)
						udp_msg = rs2.udp_message
						puts "=================Message from UDP server==============="
						print udp_msg+"\n"
						assert_match(/#{@ts_conn_state}/, udp_msg, "开启虚拟服务器后，UDP连接失败")
				}

				operate("3、重启DUT，查看配置的规则是否存在生效；") {
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

						#查询PC IP地址
						ip_info    = netsh_if_ip_show(nicname: @ts_nicname, type: "addresses")
						@tc_pc_ip2 = ip_info[:ip][0]
						puts "after router reboot，pc ip addr is: #{@tc_pc_ip}"
						puts "after router reboot，Virtual Server IP is:#{@tc_pc_ip}"
						unless @tc_pc_ip2==@tc_pc_ip
								puts "after router reboot，启动新virtual Server IP #{@tc_pc_ip2}".encode("GBK")
								#启动tcp_server
								tcp_multi_server(@tc_pc_ip2, @tc_vir_tcpsrv_port)
								#启动udp server
								udp_server(@tc_pc_ip2, @tc_vir_udpsrv_port)
						end

						#连接虚拟服务器
						rs      = @tc_wan_drb.tcp_client(@tc_static_ip, @tc_pub_tcp_port)
						tcp_msg = rs.tcp_message
						puts "=================Message from TCP server==============="
						print tcp_msg
						assert_match(/#{@ts_conn_state}/, tcp_msg, "after router reboot，开启虚拟服务器后，tcp连接失败")
						#udp客户端口也动态生成
						rs2     = @tc_wan_drb.udp_client(@ts_wan_client_ip, rand_port, @tc_static_ip, @tc_pub_udp_port)
						udp_msg = rs2.udp_message
						puts "=================Message from UDP server==============="
						print udp_msg+"\n"
						assert_match(/#{@ts_conn_state}/, udp_msg, "after router reboot，开启虚拟服务器后，UDP连接失败")

						#打开高级设置
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

						#选择“虚拟服务器”标签
						virtualsrv       = @advance_iframe.link(id: @ts_tag_virtualsrv)
						virtualsrv_state = virtualsrv.parent.class_name
						virtualsrv.click unless virtualsrv_state==@ts_tag_liclass
						sleep @tc_wait_time
						#打开虚拟服务器开关
						rs = @advance_iframe.button(id: @ts_tag_virtualsrv_sw, class_name: @ts_tag_virsw_on).exists?
						assert(rs, "重启后虚拟服务器开关被关闭")

						virsrv_ip1      = @advance_iframe.text_field(name: @ts_tag_virip1).value
						virsrv_pub_port1= @advance_iframe.text_field(name: @ts_tag_virpub_port1).value
						vrisrv_port1    = @advance_iframe.text_field(name: @ts_tag_virpri_port1).value
						assert_equal(@tc_pc_ip, virsrv_ip1, "重启路由器后虚拟服务器IP地址错误")
						assert_equal(@tc_pub_tcp_port.to_s, virsrv_pub_port1, "重启路由器后对外端口#{@tc_pub_tcp_port}错误")
						assert_equal(@tc_vir_tcpsrv_port.to_s, vrisrv_port1, "重启路由器后虚拟服务器实际端口#{@tc_vir_tcpsrv_port}错误")

						virsrv_ip2      = @advance_iframe.text_field(name: @ts_tag_virip2).value
						virsrv_pub_port2= @advance_iframe.text_field(name: @ts_tag_virpub_port2).value
						vrisrv_port2    = @advance_iframe.text_field(name: @ts_tag_virpri_port2).value
						assert_equal(@tc_pc_ip, virsrv_ip2, "重启路由器后虚拟服务器IP地址错误")
						assert_equal(@tc_pub_udp_port.to_s, virsrv_pub_port2, "重启路由器后对外端口#{@tc_pub_udp_port}错误")
						assert_equal(@tc_vir_udpsrv_port.to_s, vrisrv_port2, "重启路由器后虚拟服务器实际端口#{@tc_vir_udpsrv_port}错误")
				}

				operate("4、复位DUT，查看配置是否完全清空；") {
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

						#重新登录路由器
						rs_relogin = login_no_default_ip(@browser)
						assert(rs_relogin, "重新登录路由器失败!")

						#打开高级设置
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

						#选择“虚拟服务器”标签
						virtualsrv       = @advance_iframe.link(id: @ts_tag_virtualsrv)
						virtualsrv_state = virtualsrv.parent.class_name
						virtualsrv.click unless virtualsrv_state==@ts_tag_liclass
						sleep @tc_wait_time
						#打开虚拟服务器开关
						rs = @advance_iframe.button(id: @ts_tag_virtualsrv_sw, class_name: @ts_tag_virsw_off).exists?
						assert(rs, "恢复出厂设置后虚拟服务器开关未关闭")

						rs2 = @advance_iframe.text_field(name: @ts_tag_virip1).exists?
						refute(rs2, "恢复出厂设置后，虚拟服务器配置1未删除")

						rs3 = @advance_iframe.text_field(name: @ts_tag_virip2).exists?
						refute(rs3, "恢复出厂设置后，虚拟服务器配置2未删除")
				}


		end

		def clearup
				# operate("恢复为默认设置") {
				# 		login_router_recover(@browser, @ts_default_ip)
				# }

				operate("1 恢复默认DHCP接入") {
						if @browser.span(:id => @ts_tag_netset).exists?
								@browser.span(:id => @ts_tag_netset).click
								@wan_iframe = @browser.iframe(src: @ts_tag_netset_src)
						end

						unless @browser.span(:id => @ts_tag_netset).exists?
								login_recover(@browser, @ts_default_ip)
								@browser.span(:id => @ts_tag_netset).click
								@wan_iframe = @browser.iframe(src: @ts_tag_netset_src)
						end

						flag = false
						#设置wan连接方式为网线连接
						rs1  = @wan_iframe.link(:id => @ts_tag_wired_mode_link)
						unless rs1.class_name =~/#{@tc_tag_select_state}/
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
				}

				operate("2 删除虚拟服务器配置") {
						@browser.link(id: @ts_tag_options).wait_until_present(@tc_wait_time)
						@browser.link(id: @ts_tag_options).click
						sleep @tc_wait_time
						@advance_iframe  = @browser.iframe(src: @ts_tag_advance_src)

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
