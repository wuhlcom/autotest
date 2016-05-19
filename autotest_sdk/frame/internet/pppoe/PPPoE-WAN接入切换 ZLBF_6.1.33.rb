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
				@tc_domain        = "www.baidu.com"
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
						#设置为PPPOE拨号
						@browser.span(:id => @ts_tag_netset).click
						@wan_iframe = @browser.iframe(src: @ts_tag_netset_src)
						assert(@wan_iframe.exists?, "打开外网设置失败")

						rs1=@wan_iframe.link(:id => @ts_tag_wired_mode_link).class_name
						unless rs1 =~/#{@ts_tag_select_state}/
								@wan_iframe.span(:id => @ts_tag_wired_mode_span).click
						end
						pppoe_radio       = @wan_iframe.radio(id: @ts_tag_wired_pppoe)
						pppoe_radio_state = pppoe_radio.checked?
						unless pppoe_radio_state
								pppoe_radio.click
						end
						puts "设置PPPOE帐户名和PPPOE密码！".to_gbk
						@wan_iframe.text_field(id: @ts_tag_pppoe_usr).set(@ts_pppoe_usr)
						@wan_iframe.text_field(id: @ts_tag_pppoe_usr).set(@ts_pppoe_usr) unless @wan_iframe.text_field(id: @ts_tag_pppoe_usr).value == @ts_pppoe_usr
						@wan_iframe.text_field(id: @ts_tag_pppoe_pw).set(@ts_pppoe_pw)
						@wan_iframe.text_field(id: @ts_tag_pppoe_pw).set(@ts_pppoe_pw) unless @wan_iframe.text_field(id: @ts_tag_pppoe_pw).value == @ts_pppoe_pw
						@wan_iframe.button(id: @ts_tag_sbm).click
						puts "set pppoe mode,waiting for net reset..."
						sleep @tc_net_time
						if @browser.div(class_name: @ts_aui_state).exists?||@browser.div(class_name: @ts_aui_state_focus).exists?
								@browser.execute_script(@ts_close_div)
						end

						#多次查询状态页面,防止状态页面显示失败
						3.times do
								@browser.refresh
								@browser.span(:id => @ts_tag_status).wait_until_present(@tc_wait_time)
								@browser.span(:id => @ts_tag_status).click
								sleep @tc_wait_time
								@status_iframe = @browser.iframe(src: @ts_tag_status_iframe_src)
								break if @status_iframe.b(:id => @ts_tag_wan_ip).exists?
								sleep @tc_status_time
						end

						wan_addr = @status_iframe.b(:id => @ts_tag_wan_ip).parent.text
						wan_type = @status_iframe.b(:id => @ts_tag_wan_type).parent.text
						assert_match @ip_regxp, wan_addr, 'PPPOE获取ip地址失败！'
						assert_match /#{@ts_wan_mode_pppoe}/, wan_type, '接入类型错误！'

						rs = ping(@tc_domain)
						assert(rs, "无法连接外网")
				}

				operate("3、切换DUT的WAN方式为DHCP方式后，BAS抓包确认切换成DHCP时，是否发送LCP Termination、PADT终止当前PPPoE连接，再切换成PPPoE方式后，是否能快速拨号成功；") {
						if @browser.div(class_name: @ts_aui_state).exists?||@browser.div(class_name: @ts_aui_state_focus).exists?
								@browser.execute_script(@ts_close_div)
						end
						puts "从PPPOE切换到DHCP模式".to_gbk
						@browser.span(:id => @ts_tag_netset).click
						@wan_iframe = @browser.iframe(src: @ts_tag_netset_src)

						rs1 = @wan_iframe.link(:id => @ts_tag_wired_mode_link).class_name
						unless rs1 =~/#{@ts_tag_select_state}/
								@wan_iframe.span(:id => @ts_tag_wired_mode_span).click
						end

						dhcp_radio       = @wan_iframe.radio(id: @ts_tag_wired_dhcp)
						dhcp_radio_state = dhcp_radio.checked?
						#设置WIRE WAN为DHCP模式
						unless dhcp_radio_state
								dhcp_radio.click
						end

						capture_rs = []
						begin
								thr = Thread.new do
										capture_rs = @tc_server_obj.tshark_display_filter_fields(@tc_pppoe_args)
								end

								#切换为dhcp
								@wan_iframe.button(id: @ts_tag_sbm).click
								puts "set dhcp mode from pppoe waiting for net reset..."
								sleep @tc_net_time

								#多次查询状态页面
								3.times do
										@browser.refresh
										@browser.span(:id => @ts_tag_status).wait_until_present(@tc_wait_time)
										@browser.span(:id => @ts_tag_status).click
										sleep @tc_wait_time
										@status_iframe = @browser.iframe(src: @ts_tag_status_iframe_src)
										break if @status_iframe.b(:id => @ts_tag_wan_ip).exists?
										sleep @tc_status_time
								end

								wan_addr = @status_iframe.b(:id => @ts_tag_wan_ip).parent.text
								wan_type = @status_iframe.b(:id => @ts_tag_wan_type).parent.text
								assert_match @ip_regxp, wan_addr, 'DHCP获取ip地址失败！'
								assert_match /#{@ts_wan_mode_dhcp}/, wan_type, '接入类型错误！'

								thr.join if thr.alive?
						rescue => ex
								p ex.messge.to_s
								assert(false, "Capture PADT Packets ERROR")
						end
						#如果capture_rs不为空说明抓到了报文
						puts "Capture Result: #{capture_rs}"
						refute(capture_rs.empty?, "未抓到PADT报文")
						rs = ping(@tc_domain)
						assert(rs, "dhcp方式无法连接外网")

						if @browser.div(class_name: @ts_aui_state).exists?||@browser.div(class_name: @ts_aui_state_focus).exists?
								@browser.execute_script(@ts_close_div)
						end

						@browser.span(:id => @ts_tag_netset).click
						@wan_iframe = @browser.iframe(src: @ts_tag_netset_src)

						rs1 = @wan_iframe.link(:id => @ts_tag_wired_mode_link).class_name
						unless rs1 =~/#{@ts_tag_select_state}/
								@wan_iframe.span(:id => @ts_tag_wired_mode_span).click
						end

						#从DHCP切换回PPPOE方式
						pppoe_radio       = @wan_iframe.radio(id: @ts_tag_wired_pppoe)
						pppoe_radio_state = pppoe_radio.checked?
						unless pppoe_radio_state
								pppoe_radio.click
						end

						puts "设置PPPOE帐户名和PPPOE密码！".to_gbk
						@wan_iframe.text_field(id: @ts_tag_pppoe_usr).set(@ts_pppoe_usr)
						@wan_iframe.text_field(id: @ts_tag_pppoe_usr).set(@ts_pppoe_usr) unless @wan_iframe.text_field(id: @ts_tag_pppoe_usr).value == @ts_pppoe_usr
						@wan_iframe.text_field(id: @ts_tag_pppoe_pw).set(@ts_pppoe_pw)
						@wan_iframe.text_field(id: @ts_tag_pppoe_pw).set(@ts_pppoe_pw) unless @wan_iframe.text_field(id: @ts_tag_pppoe_pw).value == @ts_pppoe_pw
						@wan_iframe.button(id: @ts_tag_sbm).click
						puts "set pppoe from dhcp waiting for net reset..."
						sleep @tc_net_time

						#多次查询状态页面,防止状态页面显示失败
						3.times do
								@browser.refresh
								@browser.span(:id => @ts_tag_status).wait_until_present(@tc_wait_time)
								@browser.span(:id => @ts_tag_status).click
								sleep @tc_wait_time
								@status_iframe = @browser.iframe(src: @ts_tag_status_iframe_src)
								break if @status_iframe.b(:id => @ts_tag_wan_ip).exists?
								sleep @tc_status_time
						end

						wan_addr = @status_iframe.b(:id => @ts_tag_wan_ip).parent.text
						wan_type = @status_iframe.b(:id => @ts_tag_wan_type).parent.text
						assert_match @ip_regxp, wan_addr, 'PPPOE获取ip地址失败！'
						assert_match /#{@ts_wan_mode_pppoe}/, wan_type, '接入类型错误！'

						rs = ping(@tc_domain)
						assert(rs, "从DHCP切回到PPPOE无法连接外网")
				}

				operate("4、切换DUT的WAN方式分别为STATIC、L2TP、PPTP等其它接入方式，重复步骤3，确认结果；") {
						if @browser.div(class_name: @ts_aui_state).exists?||@browser.div(class_name: @ts_aui_state_focus).exists?
								@browser.execute_script(@ts_close_div)
						end

						#切换到静态IP
						puts "从PPPOE切换到静态IP模式".to_gbk
						@browser.span(:id => @ts_tag_netset).click
						@wan_iframe = @browser.iframe(src: @ts_tag_netset_src)

						rs1 = @wan_iframe.link(:id => @ts_tag_wired_mode_link).class_name
						unless rs1 =~/#{@ts_tag_select_state}/
								@wan_iframe.span(:id => @ts_tag_wired_mode_span).click
						end

						static_radio = @wan_iframe.radio(:id => @ts_tag_wired_static)
						static_radio.click
						sleep @tc_wait_time
						puts "静态IP模式地址为：#{@ts_staticIp}".to_gbk
						@wan_iframe.text_field(:id, @ts_tag_staticIp).set(@ts_staticIp)
						@wan_iframe.text_field(:id, @ts_tag_staticIp).set(@ts_staticIp) unless @wan_iframe.text_field(:id, @ts_tag_staticIp).value == @ts_staticIp
						@wan_iframe.text_field(:id, @ts_tag_staticNetmask).set(@ts_staticNetmask)
						@wan_iframe.text_field(:id, @ts_tag_staticNetmask).set(@ts_staticNetmask) unless @wan_iframe.text_field(:id, @ts_tag_staticNetmask).value == @ts_staticNetmask
						@wan_iframe.text_field(:id, @ts_tag_staticGateway).set(@ts_staticGateway)
						@wan_iframe.text_field(:id, @ts_tag_staticGateway).set(@ts_staticGateway) unless @wan_iframe.text_field(:id, @ts_tag_staticGateway).value == @ts_staticGateway
						@wan_iframe.text_field(:id, @ts_tag_staticPriDns).set(@ts_staticPriDns)
						@wan_iframe.text_field(:id, @ts_tag_staticPriDns).set(@ts_staticPriDns) unless @wan_iframe.text_field(:id, @ts_tag_staticPriDns).value == @ts_staticPriDns
						#配置备用DNS
						if @wan_iframe.text_field(:id, @ts_tag_backupDns).exists?
								@wan_iframe.text_field(:id, @ts_tag_backupDns).set(@ts_staticBackupDns)
								@wan_iframe.text_field(:id, @ts_tag_backupDns).set(@ts_staticBackupDns) unless @wan_iframe.text_field(:id, @ts_tag_backupDns).value == @ts_staticBackupDns
						end

						capture_rs = []
						begin
								thr = Thread.new do
										capture_rs = @tc_server_obj.tshark_display_filter_fields(@tc_pppoe_args)
								end
								#切换为static
								@wan_iframe.button(id: @ts_tag_sbm).click
								puts "set static from pppoe waiting for net reset..."
								sleep @tc_net_time

								#多次查询状态页面
								3.times do
										@browser.refresh
										@browser.span(:id => @ts_tag_status).wait_until_present(@tc_wait_time)
										@browser.span(:id => @ts_tag_status).click
										sleep @tc_wait_time
										@status_iframe = @browser.iframe(src: @ts_tag_status_iframe_src)
										break if @status_iframe.b(:id => @ts_tag_wan_ip).exists?
										sleep @tc_status_time
								end

								wan_addr = @status_iframe.b(:id => @ts_tag_wan_ip).parent.text
								wan_type = @status_iframe.b(:id => @ts_tag_wan_type).parent.text
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
						rs = ping(@tc_domain)
						assert(rs, "静态方式无法连接外网")

						if @browser.div(class_name: @ts_aui_state).exists?||@browser.div(class_name: @ts_aui_state_focus).exists?
								@browser.execute_script(@ts_close_div)
						end

						@browser.span(:id => @ts_tag_netset).click
						@wan_iframe = @browser.iframe(src: @ts_tag_netset_src)

						rs1 = @wan_iframe.link(:id => @ts_tag_wired_mode_link).class_name
						unless rs1 =~/#{@ts_tag_select_state}/
								@wan_iframe.span(:id => @ts_tag_wired_mode_span).click
						end

						#从静态IP切换回再次切换回PPPOE方式
						pppoe_radio       = @wan_iframe.radio(id: @ts_tag_wired_pppoe)
						pppoe_radio_state = pppoe_radio.checked?
						unless pppoe_radio_state
								pppoe_radio.click
						end

						puts "设置PPPOE帐户名和PPPOE密码！".to_gbk
						@wan_iframe.text_field(id: @ts_tag_pppoe_usr).set(@ts_pppoe_usr)
						@wan_iframe.text_field(id: @ts_tag_pppoe_usr).set(@ts_pppoe_usr) unless @wan_iframe.text_field(id: @ts_tag_pppoe_usr).value == @ts_pppoe_usr
						@wan_iframe.text_field(id: @ts_tag_pppoe_pw).set(@ts_pppoe_pw)
						@wan_iframe.text_field(id: @ts_tag_pppoe_pw).set(@ts_pppoe_pw) unless @wan_iframe.text_field(id: @ts_tag_pppoe_pw).value == @ts_pppoe_pw
						@wan_iframe.button(id: @ts_tag_sbm).click
						puts "set pppoe from dhcp waiting for net reset..."
						sleep @tc_net_time

						#多次查询状态页面,防止状态页面显示失败
						3.times do
								@browser.refresh
								@browser.span(:id => @ts_tag_status).wait_until_present(@tc_wait_time)
								@browser.span(:id => @ts_tag_status).click
								sleep @tc_wait_time
								@status_iframe = @browser.iframe(src: @ts_tag_status_iframe_src)
								break if @status_iframe.b(:id => @ts_tag_wan_ip).exists?
								sleep @tc_status_time
						end

						wan_addr = @status_iframe.b(:id => @ts_tag_wan_ip).parent.text
						wan_type = @status_iframe.b(:id => @ts_tag_wan_type).parent.text
						assert_match @ip_regxp, wan_addr, 'PPPOE获取ip地址失败！'
						assert_match /#{@ts_wan_mode_pppoe}/, wan_type, '接入类型错误！'

						if @browser.div(class_name: @ts_aui_state).exists?||@browser.div(class_name: @ts_aui_state_focus).exists?
								@browser.execute_script(@ts_close_div)
						end
						rs = ping(@tc_domain)
						assert(rs, "从static切回到PPPOE无法连接外网")

						puts "从PPPOE模式切换为PPTP模式".encode("GBK")
						option = @browser.link(:id => @ts_tag_options)
						option.wait_until_present(@tc_wait_time)
						option.click
						@advance_ifrmame = @browser.iframe(src: @ts_tag_advance_src)
						assert(@advance_ifrmame.exists?, '打开高级设置失败！')

						network_class = @advance_ifrmame.link(:id, @ts_tag_op_network).class_name
						unless network_class =~ /#{@tc_tag_select_state}/
								@advance_ifrmame.link(:id, @ts_tag_op_network).click
								sleep @tc_wait_time
						end
						@advance_ifrmame.link(:href, @tc_tag_link_href).click
						sleep @tc_wait_time
						pptp_li = @advance_ifrmame.ul(:id, @tc_tag_ul_id).lis[2].class_name
						assert_equal @tc_tag_li_class, pptp_li, '选择PPTP连接方式失败！'
						puts "设置非法的pptp帐户".to_gbk
						puts "PPTP Server:#{@ts_pptp_server_ip}"
						puts "PPTP User:#{@ts_pptp_usr}"
						puts "PPTP PassWD:#{@ts_pptp_usr}"

						@advance_ifrmame.text_field(:id, @ts_tag_pptp_server).set(@ts_pptp_server_ip)
						@advance_ifrmame.text_field(:id, @ts_tag_pptp_server).set(@ts_pptp_server_ip) unless @advance_ifrmame.text_field(:id, @ts_tag_pptp_server).value == @ts_pptp_server_ip
						@advance_ifrmame.text_field(:id, @ts_tag_pptp_usr).set(@ts_pptp_usr)
						@advance_ifrmame.text_field(:id, @ts_tag_pptp_usr).set(@ts_pptp_usr) unless @advance_ifrmame.text_field(:id, @ts_tag_pptp_usr).value == @ts_pptp_usr
						@advance_ifrmame.text_field(:id, @ts_tag_pptp_pw).set(@ts_pptp_usr)
						@advance_ifrmame.text_field(:id, @ts_tag_pptp_pw).set(@ts_pptp_usr) unless @advance_ifrmame.text_field(:id, @ts_tag_pptp_pw).value == @ts_pptp_usr

						capture_rs = []
						begin
								thr = Thread.new do
										capture_rs = @tc_server_obj.tshark_display_filter_fields(@tc_pppoe_args)
								end
								#切换为dhcp
								@advance_ifrmame.button(:id, @ts_tag_sbm).click
								puts "set pptp mode from pppoe waiting for net reset..."
								sleep @tc_net_time

								#多次查询状态页面
								3.times do
										@browser.refresh
										@browser.span(:id => @ts_tag_status).wait_until_present(@tc_wait_time)
										@browser.span(:id => @ts_tag_status).click
										sleep @tc_wait_time
										@status_iframe = @browser.iframe(src: @ts_tag_status_iframe_src)
										break if @status_iframe.b(:id => @ts_tag_wan_ip).exists?
										sleep @tc_status_time
								end

								wan_addr = @status_iframe.b(:id => @ts_tag_wan_ip).parent.text
								wan_type = @status_iframe.b(:id => @ts_tag_wan_type).parent.text
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
						rs = ping(@tc_domain)
						assert(rs, "pptp方式无法连接外网")
				}


		end

		def clearup

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
								puts "waiting for net reset..."
								sleep @tc_net_time
						end
				}

		end

}
