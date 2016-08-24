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
		end

		def process

				operate("1、当前AP通过DHCP接入到测试网") {
						@wan_page = RouterPageObject::WanPage.new(@browser)
						@wan_page.set_dhcp(@browser, @browser.url)
				}

				operate("2、点击系统诊断，诊断完成后查看系统信息内容是否准确，是否包括：") {
						if @browser.div(class_name: @ts_aui_state).exists?||@browser.div(class_name: @ts_aui_state_focus).exists?
								@browser.execute_script(@ts_close_div)
						end
						@diagnose_page = RouterPageObject::DiagnosePage.new(@browser)
						@diagnose_page.initialize_diag(@browser)
						@tc_diag_cpu_status = @diagnose_page.cpu_status
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
