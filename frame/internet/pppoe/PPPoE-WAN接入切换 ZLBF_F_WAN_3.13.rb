#
# description:
# author:wuhongliang
# date:2015-11-05 14:00:18
# modify:
#
testcase {
		attr = {"id" => "ZLBF_6.1.33", "level" => "P1", "auto" => "n"}

		def prepare

				DRb.start_service
				@tc_server_obj    = DRbObject.new_with_uri(@ts_drb_server2)
				@tc_tag_link_href = "pptp.asp"
				@tc_tag_li_class  = "active"
				@tc_tag_ul_id     = "safe_ul"
				@tc_net_time      = 60
				@tc_wait_time     = 2
				@tc_status_time   = 5
				@tc_cap_fields    = "-e frame.number -e eth.dst -e eth.src -e pppoe.code"
				@tc_pppoe_filter  = "pppoed && pppoe.code == 0x000000a7" #PADT code
				@tc_pppoe_args    = {nic: @ts_server_lannic, filter: @tc_pppoe_filter, duration: @tc_net_time, fields: @tc_cap_fields}
				puts "Capture filter PADT: #{@tc_pppoe_filter}"
		end

		def process

				operate("1、在BAS启动抓包；") {

				}

				operate("2、设置DUT的WAN拨号方式为PPPoE，DNS为自动获取方式，认证方法设为自动，并填写正确的拨号用户名和密码，提交，查看拨号是否成功") {
						@wan_page = RouterPageObject::WanPage.new(@browser)
						@wan_page.set_pppoe(@ts_pppoe_usr, @ts_pppoe_pw, @browser.url)
						if @browser.div(class_name: @ts_aui_state).exists?||@browser.div(class_name: @ts_aui_state_focus).exists?
								@browser.execute_script(@ts_close_div)
						end

						@sys_page = RouterPageObject::SystatusPage.new(@browser)
						@sys_page.open_systatus_page(@browser.url)
						p wan_addr     = @sys_page.get_wan_ip
						p wan_type     = @sys_page.get_wan_type
						assert_match @ip_regxp, wan_addr, 'PPPOE获取ip地址失败！'
						assert_match /#{@ts_wan_mode_pppoe}/, wan_type, '接入类型错误！'

						rs = ping(@ts_web)
						assert(rs, "无法连接外网")
				}

				operate("3、切换DUT的WAN方式为DHCP方式后，BAS抓包确认切换成DHCP时，是否发送LCP Termination、PADT终止当前PPPoE连接，再切换成PPPoE方式后，是否能快速拨号成功；") {
						if @browser.div(class_name: @ts_aui_state).exists?||@browser.div(class_name: @ts_aui_state_focus).exists?
								@browser.execute_script(@ts_close_div)
						end
						puts "从PPPOE切换到DHCP模式".to_gbk
						capture_rs = []
						begin
								thr = Thread.new do
										capture_rs = @tc_server_obj.tshark_display_filter_fields(@tc_pppoe_args)
								end

								#切换为dhcp
								@wan_page.set_dhcp_mode(@browser.url)

								@sys_page.open_systatus_page(@browser.url)
								p wan_addr     = @sys_page.get_wan_ip
								p wan_type     = @sys_page.get_wan_type
								assert_match @ip_regxp, wan_addr, 'DHCP获取ip地址失败！'
								assert_match /#{@ts_wan_mode_dhcp}/, wan_type, '接入类型错误！'

								thr.join if thr.alive?
						rescue => ex
								p ex.message.to_s
								assert(false, "Capture PADT Packets ERROR")
						end
						#如果capture_rs不为空说明抓到了报文
						puts "Capture Result: #{capture_rs}"
						refute(capture_rs.empty?, "未抓到PADT报文")
						rs = ping(@ts_web)
						assert(rs, "dhcp方式无法连接外网")

						if @browser.div(class_name: @ts_aui_state).exists?||@browser.div(class_name: @ts_aui_state_focus).exists?
								@browser.execute_script(@ts_close_div)
						end

						#切换到pppoe连接
						@wan_page.set_pppoe(@ts_pppoe_usr, @ts_pppoe_pw, @browser.url)

						@sys_page.open_systatus_page(@browser.url)
						p wan_addr     = @sys_page.get_wan_ip
						p wan_type     = @sys_page.get_wan_type
						assert_match @ip_regxp, wan_addr, 'PPPOE获取ip地址失败！'
						assert_match /#{@ts_wan_mode_pppoe}/, wan_type, '接入类型错误！'

						rs = ping(@ts_web)
						assert(rs, "从DHCP切回到PPPOE无法连接外网")
				}

				operate("4、切换DUT的WAN方式分别为STATIC、L2TP、PPTP等其它接入方式，重复步骤3，确认结果；") {
						if @browser.div(class_name: @ts_aui_state).exists?||@browser.div(class_name: @ts_aui_state_focus).exists?
								@browser.execute_script(@ts_close_div)
						end

						#切换到静态IP
						puts "从PPPOE切换到静态IP模式".to_gbk
						puts "静态IP模式地址为：#{@ts_staticIp}".to_gbk
						capture_rs = []
						begin
								thr = Thread.new do
										capture_rs = @tc_server_obj.tshark_display_filter_fields(@tc_pppoe_args)
								end
								#切换为static
								@wan_page.set_static(@ts_staticIp, @ts_staticNetmask, @ts_staticGateway, @ts_staticPriDns, @browser.url)

								@sys_page.open_systatus_page(@browser.url)
								p wan_addr     = @sys_page.get_wan_ip
								p wan_type     = @sys_page.get_wan_type
								assert_match @ip_regxp, wan_addr, '静态ip地址配置失败！'
								assert_match /#{@ts_wan_mode_static}/, wan_type, '接入类型错误！'
								thr.join if thr.alive?
						rescue => ex
								p ex.messge.to_s
								assert(false, "Capture PADT Packets ERROR")
						end
						#如果capture_rs不为空说明抓到了报文
						puts "Capture Result: #{capture_rs}"
						refute(capture_rs.empty?, "未抓到PADT报文")
						rs = ping(@ts_web)
						assert(rs, "静态方式无法连接外网")

						if @browser.div(class_name: @ts_aui_state).exists?||@browser.div(class_name: @ts_aui_state_focus).exists?
								@browser.execute_script(@ts_close_div)
						end

						#切换成pppoe连接
						@wan_page.set_pppoe(@ts_pppoe_usr, @ts_pppoe_pw, @browser.url)

						@sys_page.open_systatus_page(@browser.url)
						p wan_addr     = @sys_page.get_wan_ip
						p wan_type     = @sys_page.get_wan_type
						assert_match @ip_regxp, wan_addr, 'PPPOE获取ip地址失败！'
						assert_match /#{@ts_wan_mode_pppoe}/, wan_type, '接入类型错误！'

						if @browser.div(class_name: @ts_aui_state).exists?||@browser.div(class_name: @ts_aui_state_focus).exists?
								@browser.execute_script(@ts_close_div)
						end
						rs = ping(@ts_web)
						assert(rs, "从static切回到PPPOE无法连接外网")

						puts "从PPPOE模式切换为PPTP模式".encode("GBK")
						@options_page = RouterPageObject::OptionsPage.new(@browser)
						puts "设置非法的pptp帐户".to_gbk
						puts "PPTP Server:#{@ts_pptp_server_ip}"
						puts "PPTP User:#{@ts_pptp_usr}"
						puts "PPTP PassWD:#{@ts_pptp_usr}"

						capture_rs = []
						begin
								thr = Thread.new do
										capture_rs = @tc_server_obj.tshark_display_filter_fields(@tc_pppoe_args)
								end
								#切换为dhcp
								puts "set pptp mode from pppoe waiting for net reset..."
								@options_page.set_pptp(@ts_pptp_server_ip,@ts_pptp_usr,@ts_pptp_usr,@browser.url) #设置pptp连接

								@sys_page.open_systatus_page(@browser.url)
								p wan_addr     = @sys_page.get_wan_ip
								p wan_type     = @sys_page.get_wan_type
								assert_match @ip_regxp, wan_addr, 'PPTP获取ip地址失败！'
								assert_match /#{@ts_wan_mode_pptp}/, wan_type, '接入类型错误！'

								thr.join if thr.alive?
						rescue => ex
								p ex.messge.to_s
								assert(false, "Capture PADT Packets ERROR")
						end
						#如果capture_rs不为空说明抓到了报文
						puts "Capture Result: #{capture_rs}"
						refute(capture_rs.empty?, "未抓到PADT报文")
						rs = ping(@ts_web)
						assert(rs, "pptp方式无法连接外网")
				}

		end

		def clearup

				operate("1 恢复默认DHCP接入") {
						if @browser.div(class_name: @ts_aui_state).exists?||@browser.div(class_name: @ts_aui_state_focus).exists?
								@browser.execute_script(@ts_close_div)
						end

						wan_page = RouterPageObject::WanPage.new(@browser)
						wan_page.set_dhcp(@browser, @browser.url)
				}

		end

}
