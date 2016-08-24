#
# description:
# author:wuhongliang
# date:2015-11-05 14:00:19
# modify:
#
testcase {
		attr = {"id" => "ZLBF_17.1.4", "level" => "P2", "auto" => "n"}

		def prepare
				DRb.start_service
				@tc_wan_drb         = DRbObject.new_with_uri(@ts_drb_server2)
				#动态生成服务端口
				@tc_vir_tcpsrv_port = 41000
				@tc_pub_tcp_port    = 21000
				@tc_wait_time       = 3
				@tc_pptpset_time    = 5
				@tc_net_time        = 50
				@tc_reboot_time     = 180
				@tc_lan_sameseg_ip  = "192.168.100.2"
				@tc_lan_ip_new      = "192.168.123.1"

				@tc_tag_advance_div  = "aui_state_lock aui_state_focus" #focus在后表示选中了当前div
				@tc_tag_style_zindex = "z-index"
		end

		def process

				operate("1、恢复DUT默认配置，设置接入类型为PPTP；") {
						#打开高级设置
						option = @browser.link(:id => @ts_tag_options)
						option.click
						@advance_iframe = @browser.iframe(src: @ts_tag_advance_src)
						assert(@advance_iframe.exists?, "打开高级设置失败!")

						#选择网络连接
						network = @advance_iframe.link(:id, @ts_tag_op_network)
						unless network.class_name =~ /#{@ts_tag_select_state}/
								network.click
								sleep @tc_wait_time
						end
						@advance_iframe.link(:id, @ts_tag_op_pptp).click
						@advance_iframe.text_field(:id, @ts_tag_pptp_server).wait_until_present(@tc_pptpset_time)

						#配置PPTP接入
						puts "PPTP Server:#{@ts_pptp_server_ip}"
						puts "PPTP User:#{@ts_pptp_usr}"
						puts "PPTP PassWD:#{@ts_pptp_pw}"
						@advance_iframe.text_field(:id, @ts_tag_pptp_server).set(@ts_pptp_server_ip)
						@advance_iframe.text_field(:id, @ts_tag_pptp_usr).set(@ts_pptp_usr)
						@advance_iframe.text_field(:id, @ts_tag_pptp_pw).set(@ts_pptp_pw)
						@advance_iframe.button(:id, @ts_tag_sbm).click
						puts "Waiting for pptp connection..."
						sleep @tc_net_time #路由器网络可能还在重启，这里增加延迟

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

						#查询PPTP拨号状态
						@browser.span(:id => @ts_tag_status).wait_until_present(@tc_wait_time)
						@browser.span(:id => @ts_tag_status).click
						@status_iframe = @browser.iframe(src: @tag_status_iframe_src)
						assert(@status_iframe.exists?, '打开WAN状态失败！')
						wan_addr = @status_iframe.b(id: @ts_tag_wan_ip).parent.text
						@ts_tag_ip_regxp=~wan_addr
						@tc_pptp_ip = Regexp.last_match(1)
						puts "PPTP获取的IP地址为：#{@tc_pptp_ip}".to_gbk

						wan_type = @status_iframe.b(id: @ts_tag_wan_type).parent.text
						/(#{@ts_wan_mode_pptp})/=~wan_type
						puts "查询到接入类型为：#{Regexp.last_match(1)}".to_gbk

						assert_match @ts_tag_ip_regxp, wan_addr, 'PPTP获取ip地址失败！'
						assert_match /#{@ts_wan_mode_pptp}/, wan_type, '接入类型错误！'
				}

				operate("2、添加一条虚拟服务器规则，保存配置，验证规则是否生效；") {
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
						@advance_iframe.button(id: @ts_tag_save_btn).click
						sleep @tc_wait_time

						ip_info = @tc_wan_drb.netsh_if_ip_show(nicname: "lan", type: "addresses")
						ip_arr  = ip_info[:ip]
						flag    = ip_arr.any? { |ip| ip=~/#{@ts_wan_client_ip}/ }
						assert(flag, "未配置指定的ip地址#{@ts_wan_client_ip}")

						#查询服务器上默认路由是否存在
						routes = @tc_wan_drb.cmd_route_print()
						puts "WAN Server permanetn route info:"
						p routes[:permanent]
						temp = routes[:permanent].keys.any? { |net|
								new_net = net.sub(/\d+$/, "")
								@tc_pptp_ip=~/#{new_net}/
						}

						#如果路由不存在侧添加路由
						unless temp
								dst  = @tc_pptp_ip.sub(/\d+$/, "0")
								mask = "255.255.255.0"
								gw   = @ts_pptp_server_ip #网关为pptp服务地址
								cmd_route_add(dst, mask, gw)
						end

						# 启动tcp_server
						tcp_multi_server(@tc_pc_ip, @tc_vir_tcpsrv_port)
						# #TCP连接访问虚拟服务器
						rs2     = @tc_wan_drb.tcp_client(@tc_pptp_ip, @tc_pub_tcp_port)
						tcp_msg = rs2.tcp_message
						puts "=================Message from TCP server==============="
						print tcp_msg
						assert_match(/#{@ts_conn_state}/, tcp_msg, "开启虚拟服务器后，tcp连接失败")
				}

				operate("3、修改网关地址为与默认地址同网段的其他地址，验证步骤2中添加的规则是否生效；") {
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

						@browser.span(id: @ts_tag_lan).click
						@browser.iframe(src: @ts_tag_lan_src).wait_until_present(@tc_wait_time)

						@lan_iframe = @browser.iframe(src: @ts_tag_lan_src)
						@lan_iframe.text_field(id: @ts_tag_lanip).set(@tc_lan_sameseg_ip)
						@lan_iframe.button(id: @ts_tag_sbm).click
						puts "waiting for router reboot..."
						sleep @tc_reboot_time

						#重新登录路由器
						unless @browser.text_field(:name, @ts_tag_aduser).exist?
								@browser.cookies.clear
								@browser.goto(@tc_lan_sameseg_ip)
								rs = @browser.text_field(:name, @ts_tag_aduser).exist?
								assert(rs, '路由器无法登录！')
						end

						login_no_default_ip(@browser)
						@browser.span(id: @ts_tag_lan).click
						@browser.iframe(src: @ts_tag_lan_src).wait_until_present(@tc_wait_time)
						@lan_iframe = @browser.iframe(src: @ts_tag_lan_src)

						#重启路由器后如果PC 获取IP与原来不同则要重新启动tcp服务
						ip_info     = netsh_if_ip_show(nicname: @ts_nicname, type: "addresses")
						@tc_pc_ip2  = ip_info[:ip][0]
						puts "pc ip addr:#{@tc_pc_ip2}"
						unless @tc_pc_ip2==@tc_pc_ip
								puts "修改LAN IP 为#{@tc_lan_sameseg_ip}后， 启动新Virtual Server IP #{@tc_pc_ip2}".encode("GBK")
								#启动tcp_server
								tcp_multi_server(@tc_pc_ip2, @tc_vir_tcpsrv_port)
						end

						#TCP连接访问虚拟服务器
						rs2     = @tc_wan_drb.tcp_client(@tc_pptp_ip, @tc_pub_tcp_port)
						tcp_msg = rs2.tcp_message
						puts "=================Message from TCP server==============="
						print tcp_msg
						assert_match(/#{@ts_conn_state}/, tcp_msg, "开启虚拟服务器后，tcp连接失败")
				}

				operate("4、修改网关地址为与默认地址不同网段的地址，规则中服务IP地址是否能修改成相应网段的IP地址，若修改成功，验证规则是否生效；") {
						@lan_iframe.text_field(id: @ts_tag_lanip).set(@tc_lan_ip_new)
						@lan_iframe.button(id: @ts_tag_sbm).click
						puts "waiting for router reboot..."
						sleep @tc_reboot_time

						#重新登录路由器
						unless @browser.text_field(:name, @ts_tag_aduser).exist?
								@browser.cookies.clear
								@browser.goto(@tc_lan_ip_new)
								rs = @browser.text_field(:name, @ts_tag_aduser).exist?
								assert(rs, '路由器无法登录！')
						end

						login_no_default_ip(@browser)
						@browser.span(id: @ts_tag_lan).click
						@browser.iframe(src: @ts_tag_lan_src).wait_until_present(@tc_wait_time)
						@lan_iframe = @browser.iframe(src: @ts_tag_lan_src)

						#重启路由器后如果PC 获取IP与原来不同则要重新启动tcp服务
						ip_info     = netsh_if_ip_show(nicname: @ts_nicname, type: "addresses")
						@tc_pc_ip3  = ip_info[:ip][0]
						puts "pc ip addr:#{@tc_pc_ip3}"
						unless (@tc_pc_ip3==@tc_pc_ip) && (@tc_pc_ip3==@tc_pc_ip2)
								puts "修改LAN IP 为#{@tc_lan_ip_new}后， 启动新Virtual Server IP #{@tc_pc_ip3}".encode("GBK")
								#启动tcp_server
								tcp_multi_server(@tc_pc_ip3, @tc_vir_tcpsrv_port)
						end
						#TCP连接访问虚拟服务器
						rs2     = @tc_wan_drb.tcp_client(@tc_pptp_ip, @tc_pub_tcp_port)
						tcp_msg = rs2.tcp_message
						puts "=================Message from TCP server==============="
						print tcp_msg
						assert_match(/#{@ts_conn_state}/, tcp_msg, "开启虚拟服务器后，tcp连接失败")
				}

				operate("5、在步骤4，修改成功的基础上，再将网关地址修改成默认网段的IP地址，验证规则是否生效；") {
						@lan_iframe.text_field(id: @ts_tag_lanip).set(@ts_default_ip)
						@lan_iframe.button(id: @ts_tag_sbm).click
						puts "waiting for router reboot..."
						sleep @tc_reboot_time
						#重新登录路由器
						rs = @browser.text_field(:name, @ts_tag_aduser).wait_until_present(@tc_wait_time)
						assert rs, '跳转到登录页面失败！'
						login_no_default_ip(@browser)

						#重启路由器后如果PC 获取IP与原来不同则要重新启动tcp服务
						ip_info    = netsh_if_ip_show(nicname: @ts_nicname, type: "addresses")
						@tc_pc_ip4 = ip_info[:ip][0]
						puts "pc ip addr:#{@tc_pc_ip4}"
						unless (@tc_pc_ip4==@tc_pc_ip) && (@tc_pc_ip4==@tc_pc_ip2) && (@tc_pc_ip4==@tc_pc_ip3)
								puts "修改LAN IP 为#{@ts_default_ip}后， 启动新Virtual Server IP #{@tc_pc_ip4}".encode("GBK")
								#启动tcp_server
								tcp_multi_server(@tc_pc_ip4, @tc_vir_tcpsrv_port)
						end

						#TCP连接访问虚拟服务器
						rs2     = @tc_wan_drb.tcp_client(@tc_pptp_ip, @tc_pub_tcp_port)
						tcp_msg = rs2.tcp_message
						puts "=================Message from TCP server==============="
						print tcp_msg
						assert_match(/#{@ts_conn_state}/, tcp_msg, "开启虚拟服务器后，tcp连接失败")
				}

		end

		def clearup
				operate("恢复为默认设置") {
						login_router_recover(@browser, @ts_default_ip)
				}
		end

}
