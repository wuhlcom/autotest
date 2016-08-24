#
# description:
# author:liluping
# date:2015-09-25
# modify:
#
testcase {
		attr = {"id" => "ZLBF_4.1.10", "level" => "P1", "auto" => "n"}

		def prepare
				DRb.start_service
				@tc_dumpcap                  = DRbObject.new_with_uri(@ts_drb_pc2)
				@tc_wait_time                = 2
				@tc_net_time                 = 60
				@tc_diagnose_time            = 120
				@tc_tag_wan_mode_link        = "tab_ip"
				@tc_tag_wire_mode_radio      = "ip_type_dhcp"
				@tc_telnet_cmd               = "cat /proc/meminfo"
				@tc_net_state_dis            = "disabled"
				@tc_net_state_en             = "enabled"
				@tc_tag_wan_mode_link        = "tab_ip"
				@tc_select_state             = "selected"
				@tc_tag_wan_mode_span        = "wire"
				@tc_tag_wire_mode_radio_dhcp = "ip_type_dhcp"
				@tc_dut_wifi_ssid            = "ssid"
				@tc_dut_wifi_ssid_pwd        = "input_password1"
		end

		def process

				operate("1、当前AP通过DHCP接入到测试网") {
						#查看WAN接入方式是否为DHCP
						@browser.span(id: @ts_tag_status).wait_until_present(@tc_wait_time)
						@browser.span(id: @ts_tag_status).click
						sleep @tc_wait_time
						@status_iframe = @browser.iframe(src: @ts_tag_status_iframe_src)
						wan_type       = @status_iframe.b(:id => @ts_tag_wan_type).parent.text
						#如果不是DHCP则修改为DHCP
						unless wan_type =~ /#{@ts_wan_mode_dhcp}/
								puts "切换为DHCP接入方式".to_gbk
								if @browser.div(class_name: @ts_aui_state_focus).exists? || @browser.div(class_name: @ts_aui_state).exists?
										@browser.execute_script(@ts_close_div)
								end
								@browser.span(:id => @ts_tag_netset).click
								@wan_iframe = @browser.iframe(src: @ts_tag_netset_src)
								assert(@wan_iframe.exists?, "打开外网设置失败")
								@wan_iframe.link(:id => @ts_tag_wired_mode_link).click #选择网线连接
								dhcp_radio = @wan_iframe.radio(id: @ts_tag_wired_dhcp)
								unless dhcp_radio.checked?
										dhcp_radio.click
								end
								#保存设置，切换为DHCP模式
								@wan_iframe.button(:id, @ts_tag_sbm).click
								puts "sleep #{@tc_net_time} second for net reseting..."
								sleep @tc_net_time
						end

						rs = ping(@ts_web)
						assert(rs, "设置源IP过滤前有线客户端无法ping通#{@ts_web}")

						if @browser.div(class_name: @ts_aui_state_focus).exists? || @browser.div(class_name: @ts_aui_state).exists?
								@browser.execute_script(@ts_close_div)
						end

						@browser.span(id: @ts_tag_lan).wait_until_present(@tc_wait_time) #等待2s
						@browser.span(id: @ts_tag_lan).click

						@lan_iframe = @browser.iframe(src: @ts_tag_lan_src)
						assert(@lan_iframe.exists?, "打开内网设置失败！")
						p "获取DUT的ssid".to_gbk
						@dut_ssid = @lan_iframe.text_field(id: @tc_dut_wifi_ssid).value
						p "DUTssid --> #{@dut_ssid}".to_gbk
						@dut_ssid_pwd = @lan_iframe.text_field(id: @tc_dut_wifi_ssid_pwd).value
						p "DUTssid_pwd --> #{@dut_ssid_pwd}".to_gbk
						if @browser.div(class_name: @ts_aui_state_focus).exists? || @browser.div(class_name: @ts_aui_state).exists?
								@browser.execute_script(@ts_close_div)
						end

						#pc2连接dut无线
						p "PC2连接wifi".to_gbk
						flag ="1"
						rs   = @tc_dumpcap.connect(@dut_ssid, flag, @dut_ssid_pwd, @ts_wlan_nicname)
						assert(rs, "PC2 wifi连接失败".to_gbk)
				}

				operate("2、点击系统诊断，诊断完成后查看系统内存是否准确，是否包括：") {
						#诊断前先禁用无线wireless网卡
						@tc_dumpcap.netsh_if_setif_admin(@ts_wlan_nicname, @tc_net_state_dis) #禁用wireless网卡

						if @browser.div(class_name: @ts_aui_state_focus).exists? || @browser.div(class_name: @ts_aui_state).exists?
								@browser.execute_script(@ts_close_div)
						end
						sleep @tc_wait_time

						#open diagnose
						@browser.link(id: @ts_tag_diagnose).click()
						sleep @tc_wait_time
						#获取@browser对象下各个窗口对象的句柄对象
						@tc_handles = @browser.driver.window_handles
						assert(@tc_handles.size==2, "未打开诊断窗口")
						#通过句柄来切换不同的windows窗口
						@browser.driver.switch_to.window(@tc_handles[1]) #切换到系统诊断窗口

						Watir::Wait::until(@tc_wait_time, "正在进行路由器系统诊断") {
								@browser.h1(text: @ts_tag_diag_detecting).present?
						}
						Watir::Wait::until(@tc_diagnose_time, "系统诊断完成") {
								@browser.h1(text: /#{@ts_tag_diag_fini_success}|#{@ts_tag_diag_fini_fail}/).present?
						}

						sleep @tc_wait_time
						mem_info = @browser.span(id: "ram", class_name: "title").parent.parent.text
						mem_info =~ /\u5185\u5B58\u603B\u91CF\uFF1A(\d+)M\n\u53EF\u7528\u5185\u5B58\uFF1A(\d+)M\n\u7F13\u5B58\u5185\u5B58\uFF1A(\d+)M/
						@memtotal = ($1.to_i)*1024
						@memfree  = ($2.to_i)*1024
						@cached   = ($3.to_i)*1024
				}

				#telnet设备，查询内存数据
				telnet_init(@default_url, @ts_default_usr, @ts_default_pw)
				mem_inf = exp_memory_info(@tc_telnet_cmd)
				operate("内存总量：") {
						memtotal = mem_inf[:memtotal].to_i
						# assert_equal(memtotal, @memtotal, "设备实际内存总量与显示内存总量信息不相等，实际值:#{memtotal},路由器显示值:#{@memtotal}")
						assert(((memtotal-@memtotal)<2048 && (memtotal-@memtotal)>0), "设备实际内存总量与显示内存总量信息大小不准确，串口值：#{memtotal},路由器值：#{@memtotal}")
				}

				operate("可用内存：") {
						memfree = mem_inf[:memfree].to_i
						# assert_equal(memfree, @memfree, "设备实际可用内存与显示可用内存信息不相等，实际值:#{memfree},路由器显示值:#{@memfree}")
						assert(((memfree-@memfree)<2048 && (memfree-@memfree)>0), "设备实际可用内存与显示可用内存信息不准确，串口值：#{memfree},路由器值：#{@memfree}")
				}

				operate("缓存内存：") {
						cached = mem_inf[:cached].to_i
						# assert_equal(cached, @cached, "设备缓存内存与显示缓存内存信息不相等，实际值:#{cached},路由器显示值:#{@cached}")
						assert(((cached-@cached)<2048 && (cached-@cached)>0), "设备缓存内存与显示缓存内存信息不准确，串口值：#{cached},路由器值：#{@cached}")
				}

				operate("以上各个值可以在串口下使用命令free查看") {

				}

				operate("3、AP大量接入无线终端，并进行再次诊断查看内存否变化，通过串口命令查看系统内存信息，与页面信息是否一致") {
						#开启无线wireless网卡
						@tc_dumpcap.netsh_if_setif_admin(@ts_wlan_nicname, @tc_net_state_en) #开启wireless网卡
						sleep 10
						#切换到主窗口
						@browser.driver.switch_to.window(@tc_handles[0])
						#open diagnose
						@browser.link(id: @ts_tag_diagnose).click()
						sleep @tc_wait_time
						@tc_handles = @browser.driver.window_handles
						assert(@tc_handles.size==3, "未打开诊断窗口")
						#切换到主窗口
						@browser.driver.switch_to.window(@tc_handles[2])

						Watir::Wait::until(@tc_wait_time, "正在进行路由器系统诊断") {
								@browser.h1(text: @ts_tag_diag_detecting).present?
						}
						Watir::Wait::until(@tc_diagnose_time, "系统诊断完成") {
								@browser.h1(text: /#{@ts_tag_diag_fini_success}|#{@ts_tag_diag_fini_fail}/).present?
						}

						sleep @tc_wait_time
						mem_info_ui = @browser.span(id: "ram", class_name: "title").parent.parent.text
						mem_info_ui =~ /\u5185\u5B58\u603B\u91CF\uFF1A(\d+)M\n\u53EF\u7528\u5185\u5B58\uFF1A(\d+)M\n\u7F13\u5B58\u5185\u5B58\uFF1A(\d+)M/
						memtotal_ui = ($1.to_i)*1024
						memfree_ui  = ($2.to_i)*1024
						cached_ui   = ($3.to_i)*1024
						#查询实际内存数据
						telnet_init(@default_url, @ts_default_usr, @ts_default_pw)
						mem_inf_actul = exp_memory_info(@tc_telnet_cmd)

						memtotal_actul = mem_inf_actul[:memtotal].to_i
						# assert_equal(memtotal_actul, memtotal_ui, "设备实际内存总量与显示内存总量信息不相等，实际值:#{memtotal_actul},显示值:#{memtotal_ui}")
						assert(((memtotal_actul-memtotal_ui)<2048 && (memtotal_actul-memtotal_ui)>0), "设备实际内存总量与显示内存总量信息大小不准确，串口值：#{memtotal_actul},路由器值：#{memtotal_ui}")

						memfree_actul = mem_inf_actul[:memfree].to_i
						# assert_equal(memfree_actul, memfree_ui, "设备实际可用内存与显示可用内存信息不相等，实际值:#{memfree_actul},显示值:#{memfree_ui}")
						assert(((memfree_actul-memfree_ui)<2048 && (memfree_actul-memfree_ui)>0), "设备实际可用内存与显示可用内存信息不准确，串口值：#{memfree_actul},路由器值：#{memfree_ui}")

						cached_actul = mem_inf_actul[:cached].to_i
						# assert_equal(cached_actul, cached_ui, "设备缓存内存与显示缓存内存信息不相等，实际值:#{cached_actul},显示值:#{cached_ui}")
						assert(((cached_actul-cached_ui)<2048 && (cached_actul-cached_ui)>0), "设备缓存内存与显示缓存内存信息不准确，串口值：#{cached_actul},路由器值：#{cached_ui}")
				}


		end

		def clearup
				operate("1 恢复为默认的接入方式，DHCP接入") {
						@tc_dumpcap.netsh_if_setif_admin(@ts_wlan_nicname, @tc_net_state_en) #开启wireless网卡
						sleep @tc_wait_time
						p "断开wifi连接".to_gbk
						@tc_dumpcap.netsh_disc_all #断开wifi连接

						if @browser.div(class_name: @ts_aui_state).exists? || @browser.div(class_name: @ts_aui_state_focus).exists?
								@browser.execute_script(@ts_close_div)
						end

						unless @browser.span(:id => @ts_tag_netset).exists?
								login_recover(@browser, @ts_default_ip)
						end

						@browser.span(:id => @ts_tag_netset).click
						@wan_iframe = @browser.iframe

						flag = false
						#设置wan连接方式为网线连接
						rs1  = @wan_iframe.link(:id => @tc_tag_wan_mode_link).class_name
						unless rs1 =~/ #{@tc_select_state}/
								@wan_iframe.span(:id => @tc_tag_wan_mode_span).click
								flag = true
						end

						#查询是否为为dhcp模式
						dhcp_radio       = @wan_iframe.radio(id: @tc_tag_wire_mode_radio_dhcp)
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
		end

}

