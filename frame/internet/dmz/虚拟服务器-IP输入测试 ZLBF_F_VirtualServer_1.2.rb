#
# description:
# bug:虚拟服务器能输入与LAN相的IP地址
# author:wuhongliang
# date:2015-11-05 14:00:19
# modify:
#
testcase {
		attr = {"id" => "ZLBF_17.1.2", "level" => "P4", "auto" => "n"}

		def prepare
				@tc_pub_tcp_port    = 5869
				@tc_vir_tcpsrv_port = 80
				@tc_ip_error_tip    = "IP地址格式错误"
				@tc_ip_error_tip1   = "地址段ip有误"
		end

		def process

				operate("1、在“IP地址”输入全0，全1，或0开头地址或0结尾地址，如：0.0.0.0，255.255.255.255，0.0.0.1，192.0.0.0是否允许输入；") {
						@options_page = RouterPageObject::OptionsPage.new(@browser)
						@options_page.open_vps_step(@browser.url)
						@options_page.add_vps

						virtualsrv_ip_addr1 = "0.168.100.100"
						p "输入虚拟服务器IP地址为:#{virtualsrv_ip_addr1}".encode("GBK")
						@options_page.vps_input(virtualsrv_ip_addr1, @tc_pub_tcp_port, @tc_vir_tcpsrv_port)
						@options_page.save_vps
						error_tip = @options_page.vps_err_msg
						assert(error_tip, "未出现输入地址错误提示")
						assert_equal(@tc_ip_error_tip, error_tip, "提示信息错误")

						virtualsrv_ip_addr3 = "192.168.100.0"
						p "输入虚拟服务器IP地址为:#{virtualsrv_ip_addr3}".encode("GBK")
						@options_page.vps_input(virtualsrv_ip_addr3, @tc_pub_tcp_port, @tc_vir_tcpsrv_port)
						@options_page.save_vps
						error_tip = @options_page.vps_err_msg
						assert(error_tip, "未出现输入地址错误提示")
						assert_equal(@tc_ip_error_tip, error_tip, "提示信息错误")

				}

				operate("2、在“IP地址”输入D类地址或E类地址、组播地址，如：224.1.1.1，240.1.1.1，255.1.1.1，是否允许输入；") {
						virtualsrv_ip_addr5 = "224.168.100.10"
						p "输入虚拟服务器IP地址为:#{virtualsrv_ip_addr5}".encode("GBK")
						@options_page.vps_input(virtualsrv_ip_addr5, @tc_pub_tcp_port, @tc_vir_tcpsrv_port)
						@options_page.save_vps
						error_tip = @options_page.vps_err_msg
						assert(error_tip, "未出现输入地址错误提示")
						assert_equal(@tc_ip_error_tip1, error_tip, "提示信息错误")
				}

				operate("3、在“IP地址”输入大于255或小于0或小数的数字，如：256，-11，是否允许输入；") {
						virtualsrv_ip_addr7 = "100"
						p "输入虚拟服务器IP地址为:#{virtualsrv_ip_addr7}".encode("GBK")
						@options_page.vps_input(virtualsrv_ip_addr7, @tc_pub_tcp_port, @tc_vir_tcpsrv_port)
						@options_page.save_vps
						error_tip = @options_page.vps_err_msg
						assert(error_tip, "未出现输入地址错误提示")
						assert_equal(@tc_ip_error_tip, error_tip, "提示信息错误")

						virtualsrv_ip_addr4 = "192.168.-100.100"
						p "输入虚拟服务器IP地址为:#{virtualsrv_ip_addr4}".encode("GBK")
						@options_page.vps_input(virtualsrv_ip_addr4, @tc_pub_tcp_port, @tc_vir_tcpsrv_port)
						@options_page.save_vps
						error_tip = @options_page.vps_err_msg
						assert(error_tip, "未出现输入地址错误提示")
						assert_equal(@tc_ip_error_tip, error_tip, "提示信息错误")
				}

				operate("4、在“IP地址”输入广播地址，如：192.168.2.255,10.255.255.255，是否允许输入；") {
						virtualsrv_ip_addr4 = "192.168.100.255"
						p "输入虚拟服务器IP地址为:#{virtualsrv_ip_addr4}".encode("GBK")
						@options_page.vps_input(virtualsrv_ip_addr4, @tc_pub_tcp_port, @tc_vir_tcpsrv_port)
						@options_page.save_vps
						error_tip = @options_page.vps_err_msg
						assert(error_tip, "未出现输入地址错误提示")
						assert_equal(@tc_ip_error_tip, error_tip, "提示信息错误")
				}

				operate("5、输入与DUT WAN口的IP地址地址，是否允许输入；") {
#padding
				}

				operate("6、输入回环地址，如：127.0.0.1，是否允许输入；") {
						virtualsrv_ip_addr4 = "127.0.0.1"
						p "输入虚拟服务器IP地址为:#{virtualsrv_ip_addr4}".encode("GBK")
						@options_page.vps_input(virtualsrv_ip_addr4, @tc_pub_tcp_port, @tc_vir_tcpsrv_port)
						@options_page.save_vps
						error_tip = @options_page.vps_err_msg
						assert(error_tip, "未出现输入地址错误提示")
						assert_equal(@tc_ip_error_tip, error_tip, "提示信息错误")
				}

				operate("7、在IP地址输入A~Z,a~z,~!@#$%^等33个特殊字符，中文，空格，为空等，是否允许输入；") {
						virtualsrv_ip_addr = "中文"
						p "输入虚拟服务器IP地址为:#{virtualsrv_ip_addr}".encode("GBK")
						@options_page.vps_input(virtualsrv_ip_addr, @tc_pub_tcp_port, @tc_vir_tcpsrv_port)
						@options_page.save_vps
						error_tip = @options_page.vps_err_msg
						assert(error_tip, "未出现输入地址错误提示")
						assert_equal(@tc_ip_error_tip, error_tip, "提示信息错误")
				}

				operate("8、输入与LAN口IP同一个地址，如：192.168.100.1，是否允许输入；") {
						#正常应该不允许输入与LAN相同的地址
						ip_info = ipconfig
						srv_ip  = ip_info[@ts_nicname][:gateway][0]
						p "输入虚拟服务器IP地址为:#{srv_ip}".encode("GBK")
						@options_page.vps_input(srv_ip, @tc_pub_tcp_port, @tc_vir_tcpsrv_port)
						@options_page.save_vps
						error_tip = @options_page.vps_err_msg
						assert(error_tip, "未出现输入地址错误提示")
						assert_equal(@tc_ip_error_tip, error_tip, "提示信息错误")
				}


		end

		def clearup
				operate("1 删除虚拟服务器配置") {
						@options_page = RouterPageObject::OptionsPage.new(@browser)
						@options_page.delete_allvps_close_switch_step(@browser.url)
				}
		end

}
