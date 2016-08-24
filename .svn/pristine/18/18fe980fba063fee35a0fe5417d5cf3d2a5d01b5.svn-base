#
# description:
# author:wuhongliang
# date:2015-11-05 14:00:18
# modify:
#
testcase {
		attr = {"id" => "ZLBF_4.1.23.2", "level" => "P2", "auto" => "n"}

		def prepare
				@tc_wait_time         = 2
				@tc_status_time       = 5
				@tc_net_time          = 50
				@tc_diagnose_time     = 120
				@tc_err_staticIp      = '120.120.120.223'
				@tc_err_staticNetmask = '255.255.255.0'
				@tc_err_staticGateway = '120.120.120.1'
				@tc_err_staticPriDns  = '120.120.120.1'
		end

		def process

				operate("1、不插入3G上网卡，将WAN口为静态IP接入，静态IP地址为不能连接外网的IP") {
						@browser.span(:id => @ts_tag_netset).click
						@wan_iframe = @browser.iframe(src: @ts_tag_netset_src)
						assert(@wan_iframe.exists?, '打开外网设置失败！')

						rs1=@wan_iframe.link(:id => @ts_tag_wired_mode_link).class_name
						unless rs1 =~/#{@ts_tag_select_state}/
								@wan_iframe.span(:id => @ts_tag_wired_mode_span).click
						end

						static_radio = @wan_iframe.radio(:id => @ts_tag_wired_static)
						static_radio.click
						sleep @tc_wait_time

						puts "设置WAN静态IP无法连接外网，地址为：#{@tc_err_staticIp}".to_gbk
						@wan_iframe.text_field(:id, @ts_tag_staticIp).set(@tc_err_staticIp)
						@wan_iframe.text_field(:id, @ts_tag_staticNetmask).set(@tc_err_staticNetmask)
						@wan_iframe.text_field(:id, @ts_tag_staticGateway).set(@tc_err_staticGateway)
						@wan_iframe.text_field(:id, @ts_tag_staticPriDns).set(@tc_err_staticPriDns)
						if @wan_iframe.text_field(:id, @ts_tag_backupDns).exists?
								@wan_iframe.text_field(:id, @ts_tag_backupDns).set(@ts_staticBackupDns)
						end
						@wan_iframe.button(:id, @ts_tag_sbm).click
						sleep @tc_net_time #等待网络连接成功
						#打开路由器状态页面
						if @browser.div(class_name: @ts_aui_state).exists?||@browser.div(class_name: @ts_aui_state_focus).exists?
								@browser.execute_script(@ts_close_div)
						end
						sleep @tc_wait_time
						@browser.span(:id => @ts_tag_status).wait_until_present(@tc_wait_time)
						@browser.span(:id => @ts_tag_status).click
						sleep @tc_status_time #等待页面显示
						@status_iframe = @browser.iframe(src: @ts_tag_status_iframe_src)
						wan_addr       = @status_iframe.b(:id => @ts_tag_wan_ip).parent.text
						wan_type       = @status_iframe.b(:id => @ts_tag_wan_type).parent.text
						assert_match(/#{@tc_err_staticIp}/, wan_addr, '配置静态ip失败！')
						assert_match(/#{@ts_wan_mode_static}/, wan_type, '接入类型错误！')
				}

				operate("2、进行高级诊断") {
						if @browser.div(class_name: @ts_aui_state).exists?||@browser.div(class_name: @ts_aui_state_focus).exists?
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
						@browser.driver.switch_to.window(@tc_handles[1])
						# 打开高级诊断
						@browser.link(id: @ts_tag_ad_diagnose).click
						@browser.text_field(id: @ts_tag_url).wait_until_present(@tc_wait_time)
						@browser.text_field(id: @ts_tag_url).set(@ts_diag_web)
						@browser.button(id: @ts_tag_diag_btn).click
						Watir::Wait::until(@tc_wait_time, "正在进行高级诊断") {
								@browser.div(text: @ts_tag_diag_ad_detecting).present?
						}
						Watir::Wait::until(@tc_diagnose_time, "高级诊断完成") {
								@browser.p(text: /#{@ts_tag_diag_nettype}/).present?
						}

						tc_net_type =@browser.p(text: /#{@ts_tag_diag_nettype}/).span.text
						puts "上网连接类型：#{tc_net_type}".to_gbk
						assert_equal(@ts_wan_mode_static, tc_net_type, "上网连接类型错误")
						tc_net_status = @browser.p(text: /#{@ts_tag_net_status}/).span.text
						puts "WAN口连接状态：#{tc_net_status}".to_gbk
						assert_equal(@ts_net_link, tc_net_status, "WAN连接状态显示错误")
						tc_net_domain_ip = @browser.p(text: /#{@ts_tag_domain_ip}/).span.text
						puts "域名：#{@ts_diag_web}，解析结果：#{tc_net_domain_ip}".to_gbk
						assert_match(@ts_domina_ip_fail, tc_net_domain_ip, "域名解析成功")
						tc_loss_rate = @browser.p(text: /#{@ts_tag_loss}/).span.text
						puts "诊断过程丢包率为：#{tc_loss_rate}".to_gbk
						assert_equal(@ts_loss_rate_all, tc_loss_rate, "诊断过程丢包应为100%")
						tc_dns_status = @browser.p(text: /#{@ts_tag_dns}/).span.text
						puts "DNS解析状态：#{tc_dns_status}".to_gbk
						assert_equal(@ts_dns_status_fail, tc_dns_status, "DNS解析结果应该为失败")
						tc_http_code = @browser.p(text: /#{@ts_tag_http_status}/).span.text
						puts "HTTP响应码：#{tc_http_code}".to_gbk
						assert_equal(@ts_http_status_fail, tc_http_code, "HTTP响应码不正确")
				}


		end

		def clearup

				operate("1 恢复为默认的接入方式，DHCP接入") {
						unless @tc_handles.nil?
								@browser.driver.switch_to.window(@tc_handles[0])
						end

						if @browser.div(class_name: @ts_aui_state).exists? || @browser.div(class_name: @ts_aui_state_focus).exists?
								@browser.execute_script(@ts_close_div)
						end
						sleep @tc_wait_time
						@browser.span(:id => @ts_tag_netset).click
						@wan_iframe = @browser.iframe
						#设置wan连接方式为网线连接
						rs1         = @wan_iframe.link(:id => @ts_tag_wired_mode_link).class_name
						flag        = false
						unless rs1 =~ /#{@ts_tag_select_state}/
								@wan_iframe.span(:id => @ts_tag_wired_mode_span).click
								flag= true
						end

						#查询是否为为dhcp模式
						dhcp_radio       = @wan_iframe.radio(id: @ts_tag_wired_dhcp)
						dhcp_radio_state = dhcp_radio.checked?

						#设置WIRE WAN为dhcp
						unless dhcp_radio_state
								dhcp_radio.click
								flag= true
						end

						if flag
								@wan_iframe.button(:id, @ts_tag_sbm).click
								sleep @tc_net_time
						end
				}
		end

}
