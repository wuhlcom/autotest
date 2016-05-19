#
#description:
## 3 产品缺陷导致重启后不能自动跳转的登录界面，恢复默认配置时需要再验证
## 4 网关地址无法显示
## 新版本能显示网关，并对3/4G接口状态做了大的改动 2015-9-6
#author:wuhongliang
#date:2015-06-30 14:12:41
#modify:
#
testcase {
		attr = {"id" => "ZLBF_7.1.15", "level" => "P1", "auto" => "n"}

		def prepare
				@tc_wait_time          = 2
				@tc_net_time           = 50
				@tc_dial_time          = 90
				@tc_wan_type           ="3G/4G"
				@tc_tag_wan_span       = "set_network"
				@tc_tag_wan_iframe_src = "netset.asp"

				@tc_tag_wan_mode_link = "tab_3g"
				@tc_tag_wan_mode_span = "dial"

				@tc_tag_wan_mode_span2    = "wire"
				@tc_tag_wan_mode_link2    = "tab_ip"
				@tc_tag_wired_mode        = "ip_type_dhcp"
				@tc_tag_3g_mode           = "3g_auto_type"
				@tc_tag_check_status      = "checked"
				@tc_tag_net_reset_tip     = "aui_state_noTitle aui_state_focus aui_state_lock"
				@tc_tag_status_iframe_src = "setstatus.asp"
				@tc_tag_status_iframe     = "setstatus"
				@tc_tag_select_state      = "selected"
				@tc_tag_btn               = "submit_btn"

		end

		def process
				operate("1 打开外网连接设置") {
						@browser.span(:id => @tc_tag_wan_span).click
						@wan_iframe = @browser.iframe
						assert_match /#{@tc_tag_wan_iframe_src}/i, @wan_iframe.src, '打开外网设置失败！'
				}

				operate("2 设置3/4G连接方式") {
						Watir::Wait.until(@tc_wait_time, "等待网络连接模式出现") {
								@wan_iframe.link(:id, @tc_tag_wan_mode_link).visible?
						}
						rs1=@wan_iframe.link(:id => @tc_tag_wan_mode_link).class_name
						if rs1 !~/#{@tc_tag_select_state}/
								rs2 = @wan_iframe.span(:id => @tc_tag_wan_mode_span).click
								rs3 = @wan_iframe.link(:id => @tc_tag_wan_mode_link).class_name
								assert_match /#{@tc_tag_select_state}/, rs3, '未选择3/4G设置'
						end
				}
				operate("3 设置自动接入") {
						auto_3g       = @wan_iframe.radio(:id => @tc_tag_3g_mode)
						auto_3g_state = auto_3g.checked? #被选中就会返回"true"字符串
						auto_3g.click unless auto_3g_state
						@wan_iframe.button(:id, @tc_tag_btn).click
						# sleep @tc_wait_time
						# net_reset_div = @wan_iframe.div(class_name: @ts_tag_net_reset, text: @ts_tag_net_reset_text)
						# Watir::Wait.until(@tc_wait_time, "等待网络重启提示出现".to_gbk) {
						# 		net_reset_div.visible?
						# }
						# Watir::Wait.while(@tc_net_time, "正在重启网络配置".to_gbk) {
						# 		net_reset_div.present?
						# }
						#等待SIM卡注册成功
						puts "Waiting for dialing..."
						sleep @tc_dial_time
				}
				operate("4 验证业务") {
						rs = ping(@ts_web)
						assert(rs, '无法连接网络')
				}

				operate("5 查看WAN状态") {
						if @browser.div(class_name: @ts_aui_state_focus).exists?
								@browser.execute_script(@ts_close_div)
						end
						@browser.span(:id => @tc_tag_status_iframe).wait_until_present(@tc_wait_time)
						@browser.span(:id => @tc_tag_status_iframe).click
						Watir::Wait.until(@tc_wait_time, "系统状态窗口未出现") {
								@status_iframe = @browser.iframe(:src, @tc_tag_status_iframe_src)
								@status_iframe.present?
						}
						wan_addr     = @status_iframe.b(:id => @tag_wan_ip).parent.text
						wan_type     = @status_iframe.b(:id => @tag_wan_type).parent.text
						mask         = @status_iframe.b(:id => @tag_wan_mask).parent.text
						gateway_addr = @status_iframe.b(:id => @tag_wan_gw).parent.text
						dns_addr     = @status_iframe.b(:id => @tag_wan_dns).parent.text

						assert_match @ip_regxp, wan_addr, '3G获取ip地址失败！'
						assert_match /#{@tc_wan_type}/, wan_type, '接入类型错误！'
						assert_match @ip_regxp, gateway_addr, '3G获取网关ip地址失败！'
						assert_match @ip_regxp, mask, '3G获取ip地址掩码失败！'
						assert_match @ip_regxp, dns_addr, '3G获取dns ip地址失败！'

						sim_status = @status_iframe.p(:id => @ts_tag_sim).image(src: @ts_tag_img_normal)
						assert(sim_status.exists?, "SIM卡状态不正常")
						signal_status = @status_iframe.p(:id => @ts_tag_signal).image(src: @ts_tag_signal_normal)
						signal        = signal_status.alt
						puts "信号强度为：#{signal}".to_gbk
						assert(signal_status.exists?, "SIM卡信号不稳定")
						reg_status = @status_iframe.p(:id => @ts_tag_reg).image(src: @ts_tag_img_normal)
						assert(reg_status.exists?, "SIM卡注册不正常")
						net_status = @status_iframe.p(:id => @ts_tag_3g_net).image(src: @ts_tag_img_normal)
						assert(net_status.exists?, "SIM卡网络不正常")
						net_type = @status_iframe.p(:id => @ts_tag_3g_nettype).text
						net_type=~/([34]G)/
						puts "接入类型为：#{Regexp.last_match(1)}".to_gbk
						isp_type = @status_iframe.p(:id => @ts_tag_3g_isp).text
						isp_type=~/(\w+\s*\w+)/
						puts "运营商类型为：#{Regexp.last_match(1).strip}".to_gbk
				}

		end

		def clearup

				operate("1 恢复为默认的接入方式，DHCP接入") {
						if @browser.div(class_name: @ts_aui_state).exists? || @browser.div(class_name: @ts_aui_state).exists?
								@browser.execute_script(@ts_close_div)
						end

						#login_recover(@browser, @ts_default_ip)
						@browser.span(:id => @tc_tag_wan_span).click
						@wan_iframe = @browser.iframe
						#设置wan连接方式
						rs1         = @wan_iframe.link(:id => @tc_tag_wan_mode_link2).class_name
						flag        = false
						unless rs1 =~/#{@tc_tag_select_state}/
								@wan_iframe.span(:id => @tc_tag_wan_mode_span2).click
								flag = true
						end

						#查询是否为为dhcp模式
						dhcp_radio       = @wan_iframe.radio(id: @tc_tag_wired_mode)
						dhcp_radio_state = dhcp_radio.checked?

						#设置WIRE WAN为dhcp
						unless dhcp_radio_state
								dhcp_radio.click
								flag = true
						end
						if flag
								@wan_iframe.button(:id, @tc_tag_btn).click
								puts "Waiting for net reseting..."
								sleep @tc_net_time
						end
				}

		end

}
