#
# description:
# https不支持不需要测试
# author:wuhongliang
# date:2015-11-05 14:00:18
# modify:
#
testcase {
		attr = {"id" => "ZLBF_4.1.17", "level" => "P3", "auto" => "n"}

		def prepare
				@tc_wait_time     = 2
				@tc_net_time      = 50
				@tc_diagnose_time = 120
		end

		def process

				operate("1、外网连接正常，进入高级诊断") {
						@browser.span(:id => @ts_tag_status).wait_until_present(@tc_wait_time)
						@browser.span(:id => @ts_tag_status).click
						@status_iframe = @browser.iframe(src: @ts_tag_status_iframe_src)
						assert(@status_iframe.exists?, "打开WAN状态失败！")
						wan_type = @status_iframe.b(:id => @ts_tag_wan_type).parent.text
						#先判断是否为dhcp模式如果不是则设置为dhcp模式
						unless wan_type=~/#{@ts_wan_mode_dhcp}/
								if @browser.div(class_name: @ts_aui_state_focus).exists? || @browser.div(class_name: @ts_aui_state).exists?
										@browser.execute_script(@ts_close_div)
								end
								puts "设置WAN为DHCP接入".encode("GBK")
								@browser.span(:id => @ts_tag_netset).click
								@wan_iframe = @browser.iframe(src: @ts_tag_netset_src)
								assert(@wan_iframe.exists?, "打开外网设置失败")
								#设置有线连接
								rs1=@wan_iframe.link(:id => @ts_tag_wired_mode_link).class_name
								unless rs1=~/#{@ts_tag_select_state}/
										@wan_iframe.span(:id => @ts_tag_wired_mode_span).click
								end

								#如果不是dhcp接入就先设置为dhcp接入
								dhcp_radio = @wan_iframe.radio(id: @ts_tag_wired_dhcp)
								dhcp_radio.click
								#提交
								@wan_iframe.button(:id, @ts_tag_sbm).click
								sleep @tc_net_time
								if @browser.div(class_name: @ts_aui_state_focus).exists? || @browser.div(class_name: @ts_aui_state).exists?
										@browser.execute_script(@ts_close_div)
								end
								#重新查看网络状态
								@browser.span(:id => @ts_tag_status).wait_until_present(@tc_wait_time)
								@browser.span(:id => @ts_tag_status).click
								@status_iframe = @browser.iframe(src: @ts_tag_status_iframe_src)
								assert(@status_iframe.exists?, "重新打开WAN状态失败！")
								wan_type = @status_iframe.b(:id => @ts_tag_wan_type).parent.text
						end
						wan_addr = @status_iframe.b(:id => @ts_tag_wan_ip).parent.text
						wan_addr =~@ts_tag_ip_regxp
						puts "WAN状态显示获取的IP地址为：#{Regexp.last_match(1)}".to_gbk

						wan_type =~/(#{@ts_wan_mode_dhcp})/
						puts "WAN状态显示接入类型为：#{Regexp.last_match(1)}".to_gbk

						assert_match(@ts_tag_ip_regxp, wan_addr, 'dhcp获取ip地址失败！')
						assert_match(/#{@ts_wan_mode_dhcp}/, wan_type, '接入类型错误！')

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
				}

				# operate("2、输入以https开头的网站，例如输入https://www.alipay.com/，点击检测") {
				# 	不支持
				# }
				operate("3、输入字符串较长的网站，例如输入http://baike.baidu.com/link?url=PDK3_YCdAcpjIdxzt2W07U91kMhGXxYeiS-3hD1ye6crGuN669FZsLXWV4QXBJwAjgiW7QSzzPPXOr9Y_0X8AdXOs7uDpMowwqD1wsC7lHNVW85om_AHG5_X67qnHHLiVSYldD-_Bc4IwhMA2tdcZbYbcapM9pVyD4JfKKUX24e，点击检测") {
						tc_http_url = "http://baike.baidu.com/link?url=PDK3_YCdAcpjIdxzt2W07U91kMhGXxYeiS-3hD1ye6crGuN669FZsLXWV4QXBJwAjgiW7QSzzPPXOr9Y_0X8AdXOs7uDpMowwqD1wsC7lHNVW85om_AHG5_X67qnHHLiVSYldD-_Bc4IwhMA2tdcZbYbcapM9pVyD4JfKKUX24e/"
						puts "输入URL为：#{tc_http_url}".encode("GBK")
						@browser.text_field(id: @ts_tag_url).set(tc_http_url)
						@browser.button(id: @ts_tag_diag_btn).click
						Watir::Wait::until(@tc_wait_time, "正在进行高级诊断") {
								@browser.div(text: @ts_tag_diag_ad_detecting).present?
						}
						Watir::Wait::until(@tc_diagnose_time, "高级诊断完成") {
								@browser.p(text: /#{@ts_tag_diag_nettype}/).present?
						}
						tc_net_type =@browser.p(text: /#{@ts_tag_diag_nettype}/).span.text
						puts "上网连接类型：#{tc_net_type}".to_gbk
						assert_equal(@ts_wan_mode_dhcp, tc_net_type, "上网连接类型错误")
						tc_net_status = @browser.p(text: /#{@ts_tag_net_status}/).span.text
						puts "WAN口连接状态：#{tc_net_status}".to_gbk
						assert_equal(@ts_net_link, tc_net_status, "上网连接状态异常")
						tc_net_domain_ip = @browser.p(text: /#{@ts_tag_domain_ip}/).span.text
						puts "域名：#{@ts_diag_web}，解析为：#{tc_net_domain_ip}".to_gbk
						assert_match(@ts_ip_reg, tc_net_domain_ip, "域名解析失败")
						tc_loss_rate = @browser.p(text: /#{@ts_tag_loss}/).span.text
						puts "诊断过程丢包率为：#{@ts_loss_rate}".to_gbk
						assert_equal(@ts_loss_rate, tc_loss_rate, "诊断过程丢包过多")
						tc_dns_status = @browser.p(text: /#{@ts_tag_dns}/).span.text
						puts "DNS解析状态：#{tc_dns_status}".to_gbk
						assert_equal(@ts_dns_status, tc_dns_status, "DNS解析失败")
						tc_http_code = @browser.p(text: /#{@ts_tag_http_status}/).span.text
						puts "HTTP响应码：#{tc_http_code}".to_gbk
						assert_equal(tc_http_code, @ts_http_status, "HTTP响应错误")
				}

				operate("4、输入http开头的url为IP地址的网站，例如http://58.217.200.37,点击检测") {
						tc_http_ip = "http://58.217.200.37"
						puts "输入URL为：#{tc_http_ip}".encode("GBK")
						@browser.text_field(id: @ts_tag_url).set(tc_http_ip)
						@browser.button(id: @ts_tag_diag_btn).click
						Watir::Wait::until(@tc_wait_time, "正在进行高级诊断") {
								@browser.div(text: @ts_tag_diag_ad_detecting).present?
						}
						Watir::Wait::until(@tc_diagnose_time, "高级诊断完成") {
								@browser.p(text: /#{@ts_tag_diag_nettype}/).present?
						}
						tc_net_type =@browser.p(text: /#{@ts_tag_diag_nettype}/).span.text
						puts "上网连接类型：#{tc_net_type}".to_gbk
						assert_equal(@ts_wan_mode_dhcp, tc_net_type, "上网连接类型错误")
						tc_net_status = @browser.p(text: /#{@ts_tag_net_status}/).span.text
						puts "WAN口连接状态：#{tc_net_status}".to_gbk
						assert_equal(@ts_net_link, tc_net_status, "上网连接状态异常")
						tc_net_domain_ip = @browser.p(text: /#{@ts_tag_domain_ip}/).span.text
						puts "域名：#{@ts_diag_web}，解析为：#{tc_net_domain_ip}".to_gbk
						assert_match(@ts_ip_reg, tc_net_domain_ip, "域名解析失败")
						tc_loss_rate = @browser.p(text: /#{@ts_tag_loss}/).span.text
						puts "诊断过程丢包率为：#{@ts_loss_rate}".to_gbk
						assert_equal(@ts_loss_rate, tc_loss_rate, "诊断过程丢包过多")
						tc_dns_status = @browser.p(text: /#{@ts_tag_dns}/).span.text
						puts "DNS解析状态：#{tc_dns_status}".to_gbk
						assert_equal(@ts_dns_status, tc_dns_status, "DNS解析失败")
						tc_http_code = @browser.p(text: /#{@ts_tag_http_status}/).span.text
						puts "HTTP响应码：#{tc_http_code}".to_gbk
						assert_equal(tc_http_code, @ts_http_status, "HTTP响应错误")
				}

		end

		def clearup

		end

}
