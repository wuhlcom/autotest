#
# description:
#   产品有问题,输入与LAN相同的IP地址提示"路由器局域网IP地址格式错误"，应该提示"不能输入与路由器局域网IP相同的IP"
#   输入与局域网不同网段的IP能保存成功
# author:wuhongliang
# date:2015-11-05 14:00:19
# modify:
#
testcase {
		attr = {"id" => "ZLBF_18.1.3", "level" => "P4", "auto" => "n"}

		def prepare
				@tc_wait_time= 3
				@tc_dmz_ip1  = "0.0.0.0"
				@tc_dmz_ip2  = "255.255.255.255"
				@tc_dmz_ip3  = "0.192.168.254"

				@tc_dmz_ip4 = "224.0.0.2"
				@tc_dmz_ip5 = "240.0.0.2"

				@tc_dmz_ip6 = "256"
				@tc_dmz_ip7 = "-11"
				@tc_dmz_ip8 = "192.168.256.254"
				@tc_dmz_ip9 = "192.-11.25.254"

				@tc_dmz_ip10 = "192.168.100.255"
				@tc_dmz_ip11 = "192.168.100.0"

				@tc_dmz_ip12 = "10.10.10.3"

				@tc_dmz_ip13 = "127.0.0.2"

				@tc_ipaddr_error = "IP地址格式错误"
				@tc_ipaddr_error1 = "地址段ip有误"

		end

		def process

				operate("1、在“IP地址”输入全0，全1，或0开头地址或0结尾地址，如：0.0.0.0，255.255.255.255，0.0.0.1，192.0.0.0是否允许输入；") {
						@options_page = RouterPageObject::OptionsPage.new(@browser)
						@options_page.open_options_page(@browser.url)
						@options_page.open_apply_page
						@options_page.open_dmz_page
						dmz_switch_status = @options_page.dmz_switch_status #得到dmz开关状态
						@options_page.click_dmz_switch if dmz_switch_status == "off"
						puts "输入DMZ服务器地址为#{@tc_dmz_ip1}".encode("GBK")
						@options_page.dmz_input(@tc_dmz_ip1)
						@options_page.save_dmz
						error_tip = @options_page.dmz_err_msg
						assert(error_tip, "未提示输入错误")
						puts("ERROR TIP:#{error_tip}".encode("GBK"))
						assert_equal(@tc_ipaddr_error, error_tip, "提示内容错误")

						#配置dmz 服务器ip
						puts "输入DMZ服务器地址为#{@tc_dmz_ip2}".encode("GBK")
						@options_page.dmz_input(@tc_dmz_ip2)
						@options_page.save_dmz
						error_tip = @options_page.dmz_err_msg
						assert(error_tip, "未提示输入错误")
						puts("ERROR TIP:#{error_tip}".encode("GBK"))
						assert_equal(@tc_ipaddr_error, error_tip, "提示内容错误")

						#配置dmz 服务器ip
						puts "输入DMZ服务器地址为#{@tc_dmz_ip3}".encode("GBK")
						@options_page.dmz_input(@tc_dmz_ip3)
						@options_page.save_dmz
						error_tip = @options_page.dmz_err_msg
						assert(error_tip, "未提示输入错误")
						puts("ERROR TIP:#{error_tip}".encode("GBK"))
						assert_equal(@tc_ipaddr_error, error_tip, "提示内容错误")
				}

				operate("2、在“IP地址”输入D类地址或E类地址、组播地址，如：224.1.1.1，240.1.1.1，255.1.1.1，是否允许输入；") {
						#配置dmz 服务器ip
						puts "输入DMZ服务器地址为#{@tc_dmz_ip4}".encode("GBK")
						@options_page.dmz_input(@tc_dmz_ip4)
						@options_page.save_dmz
						error_tip = @options_page.dmz_err_msg
						assert(error_tip, "未提示输入错误")
						puts("ERROR TIP:#{error_tip}".encode("GBK"))
						assert_equal(@tc_ipaddr_error1, error_tip, "提示内容错误")

						#配置dmz 服务器ip
						puts "输入DMZ服务器地址为#{@tc_dmz_ip5}".encode("GBK")
						@options_page.dmz_input(@tc_dmz_ip5)
						@options_page.save_dmz
						error_tip = @options_page.dmz_err_msg
						assert(error_tip, "未提示输入错误")
						puts("ERROR TIP:#{error_tip}".encode("GBK"))
						assert_equal(@tc_ipaddr_error1, error_tip, "提示内容错误")
				}

				operate("3、在“IP地址”输入大于255或小于0或小数的数字，如：256，-11，是否允许输入；") {
						#配置dmz 服务器ip
						puts "输入DMZ服务器地址为#{@tc_dmz_ip6}".encode("GBK")
						@options_page.dmz_input(@tc_dmz_ip6)
						@options_page.save_dmz
						error_tip = @options_page.dmz_err_msg
						assert(error_tip, "未提示输入错误")
						puts("ERROR TIP:#{error_tip}".encode("GBK"))
						assert_equal(@tc_ipaddr_error, error_tip, "提示内容错误")

						#配置dmz 服务器ip
						puts "输入DMZ服务器地址为#{@tc_dmz_ip7}".encode("GBK")
						@options_page.dmz_input(@tc_dmz_ip7)
						@options_page.save_dmz
						error_tip = @options_page.dmz_err_msg
						assert(error_tip, "未提示输入错误")
						puts("ERROR TIP:#{error_tip}".encode("GBK"))
						assert_equal(@tc_ipaddr_error, error_tip, "提示内容错误")

						#配置dmz 服务器ip
						puts "输入DMZ服务器地址为#{@tc_dmz_ip8}".encode("GBK")
						@options_page.dmz_input(@tc_dmz_ip8)
						@options_page.save_dmz
						error_tip = @options_page.dmz_err_msg
						assert(error_tip, "未提示输入错误")
						puts("ERROR TIP:#{error_tip}".encode("GBK"))
						assert_equal(@tc_ipaddr_error, error_tip, "提示内容错误")

						#配置dmz 服务器ip
						puts "输入DMZ服务器地址为#{@tc_dmz_ip9}".encode("GBK")
						@options_page.dmz_input(@tc_dmz_ip9)
						@options_page.save_dmz
						error_tip = @options_page.dmz_err_msg
						assert(error_tip, "未提示输入错误")
						puts("ERROR TIP:#{error_tip}".encode("GBK"))
						assert_equal(@tc_ipaddr_error, error_tip, "提示内容错误")
				}

				operate("4、在“IP地址”输入广播地址，如：192.168.2.255,10.255.255.255，是否允许输入；") {
						#配置dmz 服务器ip
						puts "输入DMZ服务器地址为#{@tc_dmz_ip10}".encode("GBK")
						@options_page.dmz_input(@tc_dmz_ip10)
						@options_page.save_dmz
						error_tip = @options_page.dmz_err_msg
						assert(error_tip, "未提示输入错误")
						puts("ERROR TIP:#{error_tip}".encode("GBK"))
						assert_equal(@tc_ipaddr_error, error_tip, "提示内容错误")

						#配置dmz 服务器ip
						puts "输入DMZ服务器地址为#{@tc_dmz_ip11}".encode("GBK")
						@options_page.dmz_input(@tc_dmz_ip11)
						@options_page.save_dmz
						error_tip = @options_page.dmz_err_msg
						assert(error_tip, "未提示输入错误")
						puts("ERROR TIP:#{error_tip}".encode("GBK"))
						assert_equal(@tc_ipaddr_error, error_tip, "提示内容错误")

				}

				operate("5、输入与LAN口IP同一个地址，如：192.168.100.1，是否允许输入；") {
						ip_info   = netsh_if_ip_show(nicname: @ts_nicname, type: "addresses")
						@tc_pc_gw = ip_info[:gateway][0]
						#配置dmz 服务器ip
						puts "输入DMZ服务器地址为#{@tc_pc_gw}".encode("GBK")
						@options_page.dmz_input(@tc_pc_gw)
						@options_page.save_dmz
						error_tip = @options_page.dmz_err_msg
						assert(error_tip, "未提示输入错误")
						puts("ERROR TIP:#{error_tip}".encode("GBK"))
						assert_equal(@tc_ipaddr_error, error_tip, "提示内容错误")
				}

				operate("6、输入与DUT WAN口相同网段的地址，是否允许输入；") {
						# 配置dmz 服务器ip
						puts "输入DMZ服务器地址为#{@tc_dmz_ip12}".encode("GBK")
						@options_page.dmz_input(@tc_dmz_ip12)
						@options_page.save_dmz
						error_tip = @options_page.dmz_err_msg
						assert(error_tip, "未提示输入错误")
						puts("ERROR TIP:#{error_tip}".encode("GBK"))
						assert_equal(@tc_ipaddr_error1, error_tip, "提示内容错误")
				}

				operate("7、输入回环地址，如：127.0.0.1，是否允许输入；") {
						#配置dmz 服务器ip
						puts "输入DMZ服务器地址为#{@tc_dmz_ip13}".encode("GBK")
						@options_page.dmz_input(@tc_dmz_ip13)
						@options_page.save_dmz
						error_tip = @options_page.dmz_err_msg
						assert(error_tip, "未提示输入错误")
						puts("ERROR TIP:#{error_tip}".encode("GBK"))
						assert_equal(@tc_ipaddr_error1, error_tip, "提示内容错误")
				}

				operate("8、在IP地址输入A~Z,a~z,~!@#$%^等33个特殊字符，中文，空格，为空等，是否允许输入；") {
						#配置dmz 服务器ip
						tc_dmz_ip1="abc"
						tc_dmz_ip2=" "
						tc_dmz_ip3="#*"
						puts "输入DMZ服务器地址为#{tc_dmz_ip1}".encode("GBK")
						@options_page.dmz_input(tc_dmz_ip1)
						@options_page.save_dmz
						error_tip = @options_page.dmz_err_msg
						assert(error_tip, "未提示输入错误")
						puts("ERROR TIP:#{error_tip}".encode("GBK"))
						assert_equal(@tc_ipaddr_error, error_tip, "提示内容错误")

						puts "输入DMZ服务器地址为空格".encode("GBK")
						@options_page.dmz_input(tc_dmz_ip2)
						@options_page.save_dmz
						error_tip = @options_page.dmz_err_msg
						assert(error_tip, "未提示输入错误")
						puts("ERROR TIP:#{error_tip}".encode("GBK"))
						assert_equal(@tc_ipaddr_error, error_tip, "提示内容错误")

						puts "输入DMZ服务器地址为#{tc_dmz_ip3}".encode("GBK")
						@options_page.dmz_input(tc_dmz_ip3)
						@options_page.save_dmz
						error_tip = @options_page.dmz_err_msg
						assert(error_tip, "未提示输入错误")
						puts("ERROR TIP:#{error_tip}".encode("GBK"))
						assert_equal(@tc_ipaddr_error, error_tip, "提示内容错误")
				}


		end

		def clearup
				operate("取消DMZ") {
						if @browser.div(class_name: @ts_aui_state).exists? || @browser.div(class_name: @ts_aui_state_focus).exists?
								@browser.execute_script(@ts_close_div)
						end
						@options_page = RouterPageObject::OptionsPage.new(@browser)
						@options_page.open_options_page(@browser.url)
						@options_page.open_apply_page
						@options_page.open_dmz_page
						dmz_switch_status = @options_page.dmz_switch_status #得到dmz开关状态
						 if dmz_switch_status == "on"
								 @options_page.click_dmz_switch
								 @options_page.save_dmz
								 sleep @tc_wait_time
						 end
				}
		end

}
