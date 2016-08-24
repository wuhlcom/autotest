#
# description:
# author:wuhongliang
# date:2015-11-05 14:00:18
# modify:
#
testcase {
		attr = {"id" => "ZLBF_4.1.9", "level" => "P1", "auto" => "n"}

		def prepare
				# 处理器类型：Ralink SoC
				# 处理器型号：MIPS 24Kc V5.0
				# 系统负载：0.31
				@tc_wait_time     = 2
				@tc_status_wait   = 5
				@tc_net_time      = 50
				@tc_diagnose_time = 120
		end

		def process

				operate("1、当前AP通过DHCP接入到测试网") {
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
				}

				operate("2、点击系统诊断，诊断完成后查看系统信息内容是否准确，是否包括：") {
						if @browser.div(class_name: @ts_aui_state).exists?||@browser.div(class_name: @ts_aui_state_focus).exists?
								@browser.execute_script(@ts_close_div)
						end
						sleep @tc_wait_time
						#open diagnose
						@browser.link(id: @ts_tag_diagnose).click()
						sleep @tc_wait_time
						#得到@browser对象下各个窗口对象的句柄对象
						@tc_handles = @browser.driver.window_handles
						assert(@tc_handles.size==2, "未打开诊断窗口")
						#通过句柄来切换不同的windows窗口,这里切换到诊断窗口
						@browser.driver.switch_to.window(@tc_handles[1])
						sleep @tc_status_wait
						Watir::Wait.while(@tc_diagnose_time, "诊断过程出错") {
								puts "#{@ts_tag_diag_detecting}".to_gbk
								@browser.h1(id: @ts_tag_diag_detect, text: @ts_tag_diag_detecting).present?
						}
						Watir::Wait.until(@tc_wait_time, "诊断结果出错") {
								puts "#{@ts_tag_diag_fini_success}".to_gbk
								@browser.h1(id: @ts_tag_diag_detect, text: @ts_tag_diag_fini_success).present?
						}

						tc_diag_cpu=@browser.span(id: @ts_tag_diag_cpu, text: @ts_tag_diag_cpu_text).exists?
						assert(tc_diag_cpu, "未显示处理器状态")
						@tc_diag_cpu_status = @browser.div(xpath: @ts_tag_diag_cpu_xpath).text
						puts "CPU status:\n#{@tc_diag_cpu_status}".to_gbk
						assert_match(@ts_tag_cpu_type_reg, @tc_diag_cpu_status, "显示处理器类型异常")
						assert_match(@ts_tag_cpu_name_reg, @tc_diag_cpu_status, "显示处理器名称异常")
						assert_match(@ts_tag_cpu_load_reg, @tc_diag_cpu_status, "显示处理器负载异常")
				}

				operate("3 系统负载：") {
						/系统负载：(?<cpu_load>\d+\.\d+)/im=~@tc_diag_cpu_status
						puts "CPU LOAD:#{cpu_load}".encode("GBK")
						init_router_obj(@ts_default_ip)
						avarge_cpu = router_uptime
						print "\n"
						puts "CPU LOAD From uptime cmd:#{avarge_cpu}".encode("GBK")
						#telnet查询到与WEB查询相差0.2左右认为正常
						flag = (avarge_cpu.to_f-cpu_load.to_f)<0.2
						assert(flag, "WEB显示CPU负载与路由器实际负载不一致")
				}
				operate("4 处理器类型：") {
						#没有类型标准，所以未对类型断言
						/处理器类型：(?<cpu_type>.+)\s*处理器型号/im=~@tc_diag_cpu_status
						puts "CPU TYPE:#{cpu_type}".encode("GBK")
				}

				operate("5 处理器型号：") {
						#没有型号标准，所以未型号断言
						/处理器型号：(?<cpu_name>.+)\s*系统负载/im=~@tc_diag_cpu_status
						puts "CPU NAME:#{cpu_name}".encode("GBK")
				}

				operate("其中系统负载可以在串口下使用命令uptime查看") {
						#上面的步骤已经实现
				}


		end

		def clearup

				operate("1 关闭诊断窗口") {
				}
		end

}
