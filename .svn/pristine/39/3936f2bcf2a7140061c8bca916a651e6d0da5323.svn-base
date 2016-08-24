#
# description:
# author:wuhongliang
# date:2015-11-05 14:00:18
# modify:
#
testcase {
		attr = {"id" => "ZLBF_4.1.18", "level" => "P4", "auto" => "n"}

		def prepare
				@tc_wait_time     = 2
				@tc_net_time      = 50
				@tc_diagnose_time = 120
				@tc_tag_mod_div   = "mod-result"
				@tc_tag_mod_tip1  = "请输入要检查的网址！"
				@tc_tag_mod_tip2  = "请输入正确的网址，以http开头！"
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

				operate("2、输入非http开头的字符，例如直接输入www.baidu.com字符，点击检测") {
						tc_http1 = "www.baidu.com"
						puts "输入URL为#{tc_http1}".encode("GBK")
						@browser.text_field(id: @ts_tag_url).set(tc_http1)
						@browser.button(id: @ts_tag_diag_btn).click
						error_tip = @browser.div(class_name: @tc_tag_mod_div)
						assert(error_tip.exists?, "未提示输入错误")
						puts "ERROR TIP:#{error_tip.text}".encode("GBK")
						assert_equal(@tc_tag_mod_tip2, error_tip.text, "输入URL为#{tc_http1},提示内容错误")
						sleep @tc_wait_time
						tc_http2 = "httptest://www.baidu.com"
						puts "输入URL为#{tc_http2}".encode("GBK")
						@browser.text_field(id: @ts_tag_url).set(tc_http2)
						@browser.button(id: @ts_tag_diag_btn).click
						error_tip = @browser.div(class_name: @tc_tag_mod_div)
						assert(error_tip.exists?, "未提示输入错误")
						puts "ERROR TIP:#{error_tip.text}".encode("GBK")
						assert_equal(@tc_tag_mod_tip2, error_tip.text, "输入URL为#{tc_http2},提示内容错误")
						sleep @tc_wait_time
						tc_http3 = "httpt:www.baidu.com"
						puts "输入URL为#{tc_http3}".encode("GBK")
						@browser.text_field(id: @ts_tag_url).set(tc_http3)
						@browser.button(id: @ts_tag_diag_btn).click
						error_tip = @browser.div(class_name: @tc_tag_mod_div)
						assert(error_tip.exists?, "未提示输入错误")
						puts "ERROR TIP:#{error_tip.text}".encode("GBK")
						assert_equal(@tc_tag_mod_tip2, error_tip.text, "输入URL为#{tc_http3},提示内容错误")
						sleep @tc_wait_time
				}

				operate("3、输入“http://“，后面不输入其他值，点击检测") {
						tc_http = "http://"
						puts "输入URL为#{tc_http}".encode("GBK")
						@browser.text_field(id: @ts_tag_url).set(tc_http)
						@browser.button(id: @ts_tag_diag_btn).click
						error_tip = @browser.div(class_name: @tc_tag_mod_div)
						assert(error_tip.exists?, "未提示输入错误")
						puts "ERROR TIP:#{error_tip.text}".encode("GBK")
						assert_equal(@tc_tag_mod_tip2, error_tip.text, "输入URL为#{tc_http},提示内容错误")
						sleep @tc_wait_time
				}

				operate("4、输入值为空，点击检测") {
						tc_http = ""
						puts "输入URL为空".encode("GBK")
						@browser.text_field(id: @ts_tag_url).set(tc_http)
						@browser.button(id: @ts_tag_diag_btn).click
						error_tip = @browser.div(class_name: @tc_tag_mod_div)
						assert(error_tip.exists?, "未提示输入错误")
						puts "ERROR TIP:#{error_tip.text}".encode("GBK")
						assert_equal(@tc_tag_mod_tip1, error_tip.text, "输入URL内容为空提示内容错误")
				}


		end

		def clearup

		end

}
