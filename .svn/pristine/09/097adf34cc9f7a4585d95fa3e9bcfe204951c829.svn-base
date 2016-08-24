#
# description:
# author:wuhongliang
# date:2015-11-05 14:00:18
# modify:
#
testcase {
		attr = {"id" => "ZLBF_6.1.26", "level" => "P1", "auto" => "n"}

		def prepare
				DRb.start_service
				@tc_server_obj = DRbObject.new_with_uri(@ts_drb_server2)
				@tc_domain     = "www.baidu.com"
				@tc_cap_time   = 20
				@tc_net_time   = 50
				@tc_wait_time  = 2
				@tc_cap_fields = "-e frame.number -e eth.dst -e eth.src -e ip.src -e ip.dst -e dns.qry.name"
		end

		def process

				operate("1、BAS、LAN PC同时开启抓包；") {

				}

				operate("2、DUT上配置相应的PPPoE 方式接入配置，DNS选择自动从ISP获取，保存；") {
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
						@wan_iframe.text_field(id: @ts_tag_pppoe_pw).set(@ts_pppoe_pw)
						@wan_iframe.button(id: @ts_tag_sbm).click
						sleep @tc_net_time
				}

				operate("3、查看DUT获取的DNS信息是否正确，运行状态及设置页面显示的DNS信息显示是否正常；") {
						if @browser.div(class_name: @ts_aui_state).exists?||@browser.div(class_name: @ts_aui_state_focus).exists?
								@browser.execute_script(@ts_close_div)
						end

						@browser.span(:id => @ts_tag_status).wait_until_present(@tc_wait_time)
						@browser.span(:id => @ts_tag_status).click
						sleep @tc_wait_time
						@status_iframe = @browser.iframe(src: @ts_tag_status_iframe_src)
						wan_addr       = @status_iframe.b(:id => @ts_tag_wan_ip).parent.text
						wan_type       = @status_iframe.b(:id => @ts_tag_wan_type).parent.text
						mask           = @status_iframe.b(:id => @ts_tag_wan_mask).parent.text
						gateway_addr   = @status_iframe.b(:id => @ts_tag_wan_gw).parent.text
						dns_addr       = @status_iframe.b(:id => @ts_tag_wan_dns).parent.text
						dns_addr =~ @ts_tag_ip_regxp
						@tc_dns_addr = Regexp.last_match(1)
						assert_match @ip_regxp, wan_addr, 'PPPOE获取ip地址失败！'
						assert_match /#{@ts_wan_mode_pppoe}/, wan_type, '接入类型错误！'
						assert_match @ip_regxp, mask, 'PPPOE获取ip地址掩码失败！'
						assert_match @ip_regxp, gateway_addr, 'PPPOE获取网关ip地址失败！'
						assert_match @ip_regxp, dns_addr, 'PPPOE获取dns ip地址失败！'
				}

				operate("4、LAN PC上在DOS下输入:ipconfig/flushdns，清除PC的DNS缓存,执行ping www.sohu.com；") {
						@tc_main_filter = "dns && ip.dst==#{@tc_dns_addr}"
						@tc_main_args   ={nic: @ts_server_lannic, filter: @tc_main_filter, duration: @tc_cap_time, fields: @tc_cap_fields}
						puts "Capture filter: #{@tc_main_filter}"
						capture_rs = []
						begin
								thr = Thread.new do
										capture_rs = @tc_server_obj.tshark_display_filter_fields(@tc_main_args)
								end
								#清除DNS缓存
								ipconfig_flushdns
								rs = ping(@tc_domain)
								thr.join if thr.alive?
						rescue => ex
								p ex.messge.to_s
								assert(false, "Capture DNS Packets ERROR")
						end
						assert(rs, "无法连接外网")
						#如果capture_rs不为空说明抓到了报文
						puts "Capture Result: #{capture_rs}"
						refute(capture_rs.empty?, "未抓到DNS报文")
				}

				operate("5、在BAS抓包确认，DUT是否以获取的所有DNS服务器发送出DNS请求；") {
						#第四步已经实现
				}

				operate("6、LAN PC对www.sohu.com解释是否成功。") {
						#第四步已经实现
				}
		end

		def clearup

				operate("恢复默认DHCP接入") {
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
		end

}
